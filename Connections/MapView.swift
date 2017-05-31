//
//  MapView.swift
//  BeSafe
//
//  Created by Macbook on 10/10/16.
//  Copyright © 2016 Raihana A. Souleymane. All rights reserved.
//

import Foundation
import MapKit

@objc protocol MapViewDelegate {
    @objc optional func mapRegionChanged(_ mapView: MapView, lat: String, lng: String, widthInMetres: Double)
    @objc optional func annotationView(_ mkMapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    @objc optional func annotationSelected(_ mapView: MapView, didSelectAnnotationView view: MKAnnotationView)
    @objc optional func annotationDeselected(_ mapView: MapView, didDeselectAnnotationView view: MKAnnotationView)
}
class MapView: UIView, MKMapViewDelegate,CLLocationManagerDelegate{
    
    
    let clusteringManager = FBClusteringManager()
    
    @IBOutlet weak var mkMapView: MKMapView!
    @IBOutlet weak var trackUserBtn: UIButton!
    
    var drawingCoordinates = [NSValue]()
    var location: CGPoint = CGPoint()
    var centerOfMap: CLLocationCoordinate2D?
    let locationManager = CLLocationManager()
    var lastWidthInMetres: Double = 0
    
    //Variables to play with
    var clusterCellSize: Float = 10.0
    var delegate:MapViewDelegate?
    
    override func awakeFromNib() {
        mkMapView.delegate = self
        mkMapView.mapType = MKMapType.standard
        centerOfMap = mkMapView.region.center
        clusteringManager.delegate = self;
        lastWidthInMetres = self.mkMapView.getMapWidthInMeters()
        
        
        
        
        self.locationManager.delegate =  self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        // show the blue dot at the user Location pin
        self.mkMapView.showsUserLocation = true
        
        
    }
    
    override func layoutSubviews() {
        
    }
    
    deinit {
        // perform the deinitialization
        self.mkMapView.delegate = nil
    }
    
    @IBAction func onDrawAction(_ sender: AnyObject) {
        
        
    }
    
    @IBAction func redoSearchAction(_ sender: UIButton?) {
        
    }
    
    
    @IBAction func onCancelDrawAction(_ sender: AnyObject) {
        self.mkMapView.removeOverlays(self.mkMapView.overlays)
        
    }
    
    @IBAction func onTrackUserAction(_ sender: AnyObject) {
        let authStatus = CLLocationManager.authorizationStatus()
        if(!CLLocationManager.locationServicesEnabled() || (authStatus != CLAuthorizationStatus.authorizedAlways && authStatus != CLAuthorizationStatus.authorizedWhenInUse)) {
            let noLocationServicesAlert = UIAlertController(title: "Location Services Disabled", message: "Enable Location Services to use this feature", preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            noLocationServicesAlert.addAction(ok)
            inputViewController?.present(noLocationServicesAlert, animated: true, completion: nil)
        }
        else {
            switch(self.mkMapView.userTrackingMode){
            case MKUserTrackingMode.none:
                trackUserBtn.setImage(UIImage(named: "TrackUserSelected") as UIImage?, for: UIControlState())
                self.mkMapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
                break
            case MKUserTrackingMode.follow:
                trackUserBtn.setImage(UIImage(named: "TrackUserWithHeading") as UIImage?, for: UIControlState())
                self.mkMapView.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: true)
                break
            case MKUserTrackingMode.followWithHeading:
                trackUserBtn.setImage(UIImage(named: "TrackUserDeselect") as UIImage?, for: UIControlState())
                self.mkMapView.setUserTrackingMode(MKUserTrackingMode.none, animated: true)
                break
            }
            
        }
        
    }
    
    //MARK: - MKMap View Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        if annotation.isKind(of: FBAnnotationCluster.self) {
            //print(annotation)
            reuseId = "Cluster"
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId)
            return clusterView
            
        } else {
            reuseId = "Pin"
            return self.delegate?.annotationView?(mapView, viewForAnnotation: Crime.self as! MKAnnotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            if let _ = view.annotation as? MKUserLocation {
                view.canShowCallout = false
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.delegate?.annotationSelected?(self, didSelectAnnotationView: view)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.delegate?.annotationDeselected?(self, didDeselectAnnotationView: view)
    }
    
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        redrawAnnotations()
        if(mkMapView.userTrackingMode == MKUserTrackingMode.none){
            trackUserBtn.setImage(UIImage(named: "TrackUserDeselect") as UIImage?, for: UIControlState())
        }
        self.delegate?.mapRegionChanged?(self, lat: String(format: "%f", (mkMapView.centerCoordinate.latitude)), lng: String(format: "%f", (mkMapView.centerCoordinate.longitude)), widthInMetres: mapView.getMapWidthInMeters())
        
    }
    
    //MARK: - touch delegates
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.addCoordinates(touch)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.addCoordinates(touch)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        self.addCoordinates(touch)
    }
    
    //get coordinate of selected location
    func addCoordinates(_ touch: UITouch) {
        let location = touch.location(in: self.mkMapView)
        let coordinate = self.mkMapView.convert(location, toCoordinateFrom: self.mkMapView)
        self.drawingCoordinates.append(NSValue(mkCoordinate: coordinate))
    }
    
    
    func redrawAnnotations(){
        OperationQueue().addOperation({
            let mapBoundsWidth = Double(self.mkMapView.bounds.size.width)
            let mapRectWidth:Double = self.mkMapView.visibleMapRect.size.width
            let scale:Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(self.mkMapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotationArray, onMapView:self.mkMapView)
        })
    }
    
    
    func calculateMetreDistanceBetweenTwoCoords(_ sourceCoord:CLLocationCoordinate2D, destinationCoord:CLLocationCoordinate2D) -> Double{
        
        let srcLat: CLLocationDegrees = sourceCoord.latitude
        let srcLon: CLLocationDegrees = sourceCoord.longitude
        let srcLocation: CLLocation =  CLLocation(latitude: srcLat, longitude: srcLon)
        
        let destLat: CLLocationDegrees = destinationCoord.latitude
        let destLon: CLLocationDegrees = destinationCoord.longitude
        let destLocation: CLLocation =  CLLocation(latitude: destLat, longitude: destLon)
        
        let distanceMeters = srcLocation.distance(from: destLocation)
        return distanceMeters
    }
    
    func centerMapOnLocation(_ latitude: Double, longitude: Double, widthInMetres: Double) {
        //        mapLoadNotInProgress = false
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let regionWidth: CLLocationDistance = widthInMetres
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionWidth, regionWidth)
        centerOfMap = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mkMapView.setRegion(coordinateRegion, animated: false)
        lastWidthInMetres = self.mkMapView.getMapWidthInMeters()
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        //            self.mapLoadNotInProgress = true
        //        }
        //        self.delegate?.mapRegionChanged?(self, lat: "\(latitude)", lng: "\(longitude)", widthInMetres: widthInMetres)
    }
    
}

extension MapView : FBClusteringManagerDelegate {
    
    func cellSizeFactorForCoordinator(_ coordinator:FBClusteringManager) -> CGFloat{
        return CGFloat(clusterCellSize)
    }
    
}

extension MKMapView {
    func fitMapViewToAnnotaionList(_ allAnnotations: [MKAnnotation]) -> Void {
        let minWidthInMapPoints: Double = 10000.0
        let mapEdgePadding = UIEdgeInsets(top: 80, left: 20, bottom: 80, right: 20)
        var zoomRect:MKMapRect = MKMapRectNull
        
        for index in 0..<allAnnotations.count {
            let annotation = allAnnotations[index]
            if(annotation.coordinate.latitude == 0.0 && annotation.coordinate.longitude == 0.0){
                continue
            }
            let aPoint:MKMapPoint = MKMapPointForCoordinate(annotation.coordinate)
            let rect:MKMapRect = MKMapRectMake(aPoint.x - minWidthInMapPoints/2, aPoint.y - minWidthInMapPoints/2, minWidthInMapPoints, minWidthInMapPoints)
            
            if MKMapRectIsNull(zoomRect) {
                zoomRect = rect
            } else {
                zoomRect = MKMapRectUnion(zoomRect, rect)
            }
        }
        self.setVisibleMapRect(zoomRect, edgePadding: mapEdgePadding, animated: false)
    }
    
    func getMapWidthInMeters()->Double{
        //let deltaLatitude: CLLocationDegrees = self.mkMapView.region.span.latitudeDelta
        let deltaLongitude: CLLocationDegrees = self.region.span.longitudeDelta
        let latitudeCircumference: Double = Double(40075160) * cos(self.region.center.latitude * M_PI / 180)
        return (deltaLongitude * latitudeCircumference / Double(360))
        //        print(deltaLongitude * latitudeCircumference / 360)
        //        print(deltaLatitude * 40008000 / 360)
    }
    
}


