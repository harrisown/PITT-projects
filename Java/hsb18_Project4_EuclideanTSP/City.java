import java.util.ArrayList;


public class City {
public String name;
public int xCord;
public int yCord;
public City best_neighbor;
public ArrayList<City> neighbors = new ArrayList<City>();

	public City(String name,int x, int y){
		this.name = name;
		this.xCord = x;
		this.yCord = y;
	}
	public City() {
		// TODO Auto-generated constructor stub
	}
	public double distance(City otherCity){
		return Math.sqrt(Math.pow((otherCity.xCord - this.xCord),2) + Math.pow((otherCity.yCord - this.yCord),2));
	}
	public String toString(){
		return this.name+" with x cord: "+this.xCord+" with y cord: "+this.yCord;
	}
}
