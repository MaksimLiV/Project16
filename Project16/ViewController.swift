//
//  ViewController.swift
//  Project16
//
//  Created by Maksim Li on 04/04/2025.
//

import MapKit
import UIKit
import WebKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let london = Capital (title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics")
        let oslo = Capital (title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded a thousand years ago")
        let paris = Capital (title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often call the City of Love")
        let rome = Capital (title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it")
        let washington = Capital (title: "Washington", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "The capital of the USA")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
        
        let mapTypeAlert = UIAlertController(title: "Map View", message: "Choose map type", preferredStyle: .actionSheet)
        mapTypeAlert.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in self?.mapView.mapType = .standard})
        mapTypeAlert.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in self?.mapView.mapType = .satellite })
        mapTypeAlert.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in self?.mapView.mapType = .hybrid })
        mapTypeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(mapTypeAlert, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemPurple
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title ?? "Wikipedia"
        let urlString = "https://en.wikipedia.org/wiki/\(placeName.replacingOccurrences(of: " ", with: "_"))"
        let webVC = WebViewController()
        webVC.urlString = urlString
        navigationController?.pushViewController(webVC, animated: true)
    }
}

class WebViewController: UIViewController {
    var urlString: String?
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        if let urlString = urlString, let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
