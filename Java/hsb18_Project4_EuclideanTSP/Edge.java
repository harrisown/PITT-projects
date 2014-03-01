
public class Edge {
	City oneCity;
	City otherCity;
	
	public Edge(City one, City two){
		this.oneCity = one;
		this.otherCity = two;
	}
	public double distance(){
		return Math.sqrt(Math.pow((otherCity.xCord - oneCity.xCord),2) + Math.pow((otherCity.yCord - oneCity.yCord),2));
	}
	public String toString(){
		return "1: "+oneCity.name+ " 2: "+otherCity.name + " "+oneCity.distance(otherCity);
	}
}
