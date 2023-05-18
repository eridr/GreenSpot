import SwiftUI
import CoreLocation
import Combine

struct GFCourse: View {
    
    var golfClubs:[GolfClub] = GolfClubs.clubs
    
    var body: some View {
        NavigationView {
            List{
                ForEach(golfClubs, id: \.id) {thisGolfClub in
                    NavigationLink(destination: CourseView(GolfCourses: thisGolfClub.golfCourse)) {
                        HStack {
                            Image(thisGolfClub.image).resizable()
                                .aspectRatio(contentMode: .fill).frame(width: 50, height: 50, alignment: .center).clipShape(Circle())
                            Text(thisGolfClub.name).bold()
                        }
                    }
                }.listRowPlatterColor(Color(red: 13 / 255, green: 116 / 255, blue: 77 / 255))
            }
        }
    }
}

struct CourseView: View {
    
    var GolfCourses: [GolfCourse]
    
    var body: some View {
        List{
            ForEach(GolfCourses, id: \.id){thisGolfCourse in
                NavigationLink(destination: HoleOverview(GolfHoles: thisGolfCourse.holes)) {
                    Text(thisGolfCourse.name)
                }
            }.listRowPlatterColor(Color(red: 13 / 255, green: 116 / 255, blue: 77 / 255))
        }
    }
}

struct HoleOverview: View {
    var GolfHoles: [Hole]
    
    @ObservedObject private var locationManager = LocationManager()
    @State private var distanceToGreen: Double = 0.00
    @State private var cancellable: AnyCancellable?
    @State private var holeIndex: Int = 0
    
    private func setCurrentLocation() {
        cancellable =  locationManager.$location.sink { location in
            if (location != nil) {
                distanceToGreen = getDistanceToGreen(uLat: (location?.coordinate.latitude)! , uLon: (location?.coordinate.longitude)!, gLat: GolfHoles[holeIndex].location.latitude, gLon: GolfHoles[holeIndex].location.longitude)
            }
        }
    }
    
    // get distance to hole
    private func getDistanceToGreen(uLat: Double, uLon: Double, gLat:Double, gLon:Double) -> Double {
        return CLLocation(latitude: uLat, longitude: uLon).distance(from: CLLocation(latitude: gLat, longitude: gLon))
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                NavigationLink(destination: ScoreView()) {
                    Text("Score")
                }
                .background(Color(red: 0 / 255, green: 84 / 255, blue: 70 / 255))
                .clipShape(Circle())
            }
            Spacer()
            HStack{
                Text("\(holeIndex+1): ").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text("\(Int(round(distanceToGreen))) M").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            HStack{
                Button("Back", action: {
                    if (holeIndex>0) { holeIndex -= 1 }
                }).background(Color(red: 219 / 255, green: 84 / 255, blue: 70 / 255)).clipShape(Capsule())
                Button("Next", action: {
                    if (holeIndex<GolfHoles.count-1) { holeIndex += 1 }
                }).background(Color(red: 13 / 255, green: 116 / 255, blue: 77 / 255)).clipShape(Capsule())
                
            }
        }
        .onAppear {
            setCurrentLocation()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GFCourse()
    }
}

struct ScoreView: View {
    var body: some View {
        Text("Score")
    }
}
