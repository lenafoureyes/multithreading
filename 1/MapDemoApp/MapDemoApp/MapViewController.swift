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
    
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var destinationCoordinate: CLLocationCoordinate2D?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if targetEnvironment(simulator)
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        #endif
        
        setupViews()
        setupConstraints()
        configureMap()
        setupLocationManager()
        addTestPin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.bringSubviewToFront(routeButton)
    }
    
    // MARK: - Setup Methods
    private func setupViews() {
        view.backgroundColor = .white
        title = "Карта с маршрутом"
        
        // Настройка карты
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка кнопки
        routeButton.setTitle("Построить маршрут", for: .normal)
        routeButton.backgroundColor = .systemBlue
        routeButton.setTitleColor(.white, for: .normal)
        routeButton.layer.cornerRadius = 8
        routeButton.layer.shadowColor = UIColor.black.cgColor
        routeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        routeButton.layer.shadowRadius = 4
        routeButton.layer.shadowOpacity = 0.3
        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        
        view.addSubview(routeButton)
        routeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            routeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            routeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            routeButton.widthAnchor.constraint(equalToConstant: 200),
            routeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        view.bringSubviewToFront(routeButton)
    }
    
    private func configureMap() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        #if targetEnvironment(simulator)
        mapView.showsBuildings = false
        #endif
        
        mapView.mapType = .mutedStandard
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsTraffic = false
        mapView.showsCompass = true
        mapView.showsScale = true
        
        mapView.cameraZoomRange = MKMapView.CameraZoomRange(
            minCenterCoordinateDistance: 1000,
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
    
    private func addTestPin() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        let annotation = MKPointAnnotation()
        annotation.title = "Пункт назначения"
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        destinationCoordinate = coordinate
    }
    
    // MARK: - Route Methods
    @objc private func routeButtonTapped() {
        #if targetEnvironment(simulator)
        let startCoordinate = CLLocationCoordinate2D(latitude: 55.7909, longitude: 37.5867)
        let endCoordinate = CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423)
        
        let distance = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
            .distance(from: CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude))
        
        guard distance > 500 else {
            showAlert(message: "Точки слишком близко для построения маршрута")
            return
        }
        
        drawRoute(from: startCoordinate, to: endCoordinate)
        #else
        guard let startCoordinate = currentLocation?.coordinate,
              let endCoordinate = destinationCoordinate else {
            showAlert(message: "Не удалось определить местоположение")
            return
        }
        drawRoute(from: startCoordinate, to: endCoordinate)
        #endif
    }
    
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let padding = UIEdgeInsets(top: 100, left: 50, bottom: 150, right: 50)
                let mapRect = route.polyline.boundingMapRect
                let fittedRect = self.mapView.mapRectThatFits(mapRect, edgePadding: padding)
                
                UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut]) {
                    let newRegion = MKCoordinateRegion(fittedRect)
                    let fixedAltitude = max(newRegion.span.latitudeDelta, newRegion.span.longitudeDelta) * 1.5
                    
                    let camera = MKMapCamera(
                        lookingAtCenter: newRegion.center,
                        fromDistance: fixedAltitude * 111_320,
                        pitch: 0,
                        heading: 0
                    )
                    
                    self.mapView.setCamera(camera, animated: true)
                }
            }
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
        
        let region = MKCoordinateRegion(center: location.coordinate,
                                      latitudinalMeters: 1000,
                                      longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if targetEnvironment(simulator)
        print("Игнорируем ошибку локации в симуляторе")
        #else
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
            renderer.lineWidth = 6
            renderer.lineDashPattern = [2, 6]
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        routeButtonTapped()
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
