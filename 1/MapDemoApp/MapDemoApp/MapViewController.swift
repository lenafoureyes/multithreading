//
//  MapViewController.swift
//  MapDemoApp
//
//  Created by Елена Хайрова on 10.05.2025.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - UI Elements
    private let mapView = MKMapView()
    private let routeButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var destinationCoordinate: CLLocationCoordinate2D?
    private var destinationAnnotation: MKPointAnnotation?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        configureMap()
        setupLocationManager()
        setupGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(routeButton)
        view.bringSubviewToFront(clearButton)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = .white
        title = "Навигатор"
        
        // Настройка карты
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка кнопки маршрута
        routeButton.setTitle("Построить маршрут", for: .normal)
        routeButton.backgroundColor = .systemBlue
        routeButton.setTitleColor(.white, for: .normal)
        routeButton.layer.cornerRadius = 8
        routeButton.layer.shadowColor = UIColor.black.cgColor
        routeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        routeButton.layer.shadowRadius = 4
        routeButton.layer.shadowOpacity = 0.3
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        routeButton.isHidden = true
        
        // Настройка кнопки очистки
        clearButton.setTitle("Очистить", for: .normal)
        clearButton.backgroundColor = .systemRed
        clearButton.setTitleColor(.white, for: .normal)
        clearButton.layer.cornerRadius = 8
        clearButton.layer.shadowColor = UIColor.black.cgColor
        clearButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        clearButton.layer.shadowRadius = 4
        clearButton.layer.shadowOpacity = 0.3
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.isHidden = true
        
        view.addSubview(routeButton)
        view.addSubview(clearButton)
        routeButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            routeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            routeButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            routeButton.widthAnchor.constraint(equalToConstant: 180),
            routeButton.heightAnchor.constraint(equalToConstant: 50),
            
            clearButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            clearButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            clearButton.widthAnchor.constraint(equalToConstant: 180),
            clearButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = .mutedStandard
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsTraffic = false
        mapView.showsCompass = true
        mapView.showsScale = true
        
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 100,
            maxCenterCoordinateDistance: 20000
        )
        
        #if targetEnvironment(simulator)
        let defaultLocation = CLLocation(latitude: 55.751244, longitude: 37.618423)
        mapView.setRegion(MKCoordinateRegion(center: defaultLocation.coordinate,
                                          latitudinalMeters: 1000,
                                          longitudinalMeters: 1000),
                        animated: true)
        #endif
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setupGestureRecognizers() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    // MARK: - Action Methods
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            // Удаляем предыдущую точку назначения
            if let previousAnnotation = destinationAnnotation {
                mapView.removeAnnotation(previousAnnotation)
            }
            
            // Добавляем новую точку назначения
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Пункт назначения"
            mapView.addAnnotation(annotation)
            
            destinationCoordinate = coordinate
            destinationAnnotation = annotation
            
            routeButton.isHidden = false
            clearButton.isHidden = false
        }
    }
    
    @objc private func routeButtonTapped() {
        guard let destination = destinationCoordinate else {
            showAlert(message: "Сначала выберите точку назначения")
            return
        }
        
        #if targetEnvironment(simulator)
        let startCoordinate = mapView.userLocation.coordinate
        #else
        guard let startCoordinate = currentLocation?.coordinate else {
            showAlert(message: "Не удалось определить ваше местоположение")
            return
        }
        #endif
        
        drawRoute(from: startCoordinate, to: destination)
    }
    
    @objc private func clearButtonTapped() {
        mapView.removeOverlays(mapView.overlays)
        if let annotation = destinationAnnotation {
            mapView.removeAnnotation(annotation)
        }
        destinationCoordinate = nil
        destinationAnnotation = nil
        routeButton.isHidden = true
        clearButton.isHidden = true
    }
    
    // MARK: - Route Methods
    private func drawRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) {
        mapView.removeOverlays(mapView.overlays)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [weak self] (response, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(message: "Ошибка построения маршрута: \(error.localizedDescription)")
                return
            }
            
            guard let route = response?.routes.first else {
                self.showAlert(message: "Маршрут не найден")
                return
            }
            
            self.mapView.addOverlay(route.polyline)
            self.zoomToRoute(route: route)
        }
    }
    
    private func zoomToRoute(route: MKRoute) {
        let padding = UIEdgeInsets(top: 100, left: 50, bottom: 150, right: 50)
        let mapRect = route.polyline.boundingMapRect
        let fittedRect = mapView.mapRectThatFits(mapRect, edgePadding: padding)
        
        UIView.animate(withDuration: 1.0) {
            self.mapView.setVisibleMapRect(fittedRect, edgePadding: padding, animated: true)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        
        if locations.count == 1 {
            let region = MKCoordinateRegion(center: location.coordinate,
                                          latitudinalMeters: 1000,
                                          longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if !targetEnvironment(simulator)
        showAlert(message: "Ошибка получения локации: \(error.localizedDescription)")
        #endif
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showAlert(message: "Разрешите доступ к геолокации в настройках")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.systemBlue.withAlphaComponent(0.7)
            renderer.lineWidth = 5
            renderer.lineDashPattern = [2, 6]
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "destinationPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.glyphImage = UIImage(systemName: "flag.fill")
            annotationView?.markerTintColor = .systemRed
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let maxSpan: CLLocationDegrees = 0.2
        if mapView.region.span.latitudeDelta > maxSpan ||
           mapView.region.span.longitudeDelta > maxSpan {
            let clampedRegion = MKCoordinateRegion(
                center: mapView.region.center,
                span: MKCoordinateSpan(
                    latitudeDelta: min(mapView.region.span.latitudeDelta, maxSpan),
                    longitudeDelta: min(mapView.region.span.longitudeDelta, maxSpan)
                )
            )
            mapView.setRegion(clampedRegion, animated: true)
        }
    }
}
