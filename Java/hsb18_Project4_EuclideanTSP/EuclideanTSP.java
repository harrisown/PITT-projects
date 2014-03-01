import java.util.*;


public class EuclideanTSP {
	public static double MSTweight;
	public static double TourLength;

	public static ArrayList<Edge> MST(ArrayList<City>cities){
		int numCities = cities.size();
		double[]distances = new double[cities.size()-1];
		ArrayList<Edge> MST_edges = new ArrayList<Edge>();
		ArrayList<City> MST_cities = new ArrayList<City>();
		City start = cities.get(0); //generate starting city, defaulted to the first one
		MST_cities.add(start);
		cities.remove(0);
		
		for(int i = 0; i < cities.size();i++){
			double distance_to_start = cities.get(i).distance(start);
			distances[i] = distance_to_start;
			cities.get(i).best_neighbor = start;
		}
		
		
		for(int i = 0; i < numCities-1; i++){
			double current_min = 99999.9;
			int city_index = 0;
			for(int j = 0; j < cities.size();j++){ //finds minimum index from distances array
				if(distances[j] < current_min){
					current_min = distances[j];
					city_index = j; 
				}
			}
			City new_city = cities.get(city_index);//generate minimum city where distances was the smallest
			MST_cities.add(new_city);//add the city to the final tree
			MST_edges.add(new Edge(new_city,new_city.best_neighbor));//generate an edge for printing from the new city to its best_neighbor
			MSTweight += new_city.distance(new_city.best_neighbor);
			cities.remove(city_index);
			for(int z = city_index; z< distances.length-1;z++){
				distances[z] = distances[z+1];
			}
			for(int k = 0; k < cities.size();k++){
				City one = cities.get(k);
				if(distances[k] > (one.distance(new_city))){
					distances[k] = one.distance(new_city);
					one.best_neighbor = new_city;
				}
				
			}
		}
		System.out.println("MST weight is "+MSTweight);
		
		return MST_edges;
	}
	
	public static ArrayList<City> Tour(ArrayList<Edge>edges){
		//System.out.println(edges.size());
		ArrayList<City> finalCities = new ArrayList<City>();
		//boolean[]explored = new boolean[edges.size()+1];
		ArrayList[] city_edges = new ArrayList[edges.size()+1]; 
		for(int i = 0; i < city_edges.length;i++){
			city_edges[i] = new ArrayList<City>();
		}
		for(int i = 0; i < edges.size();i++){
			City one = edges.get(i).oneCity;
			City two = edges.get(i).otherCity;
			ArrayList<City> one_list = city_edges[Integer.parseInt(one.name)];
			ArrayList<City> two_list = city_edges[Integer.parseInt(two.name)];
			one_list.add(two);
			two_list.add(one);
			city_edges[Integer.parseInt(one.name)] = one_list;
			city_edges[Integer.parseInt(two.name)] = two_list;
		}
		//for(int i = 0; i < city_edges.length;i++){
			//System.out.println("City name: "+i+" "+city_edges[i]);
		//}
		boolean[]visited = new boolean[city_edges.length];
		int city_index = 0;
		int back_city = 0;
		finalCities.add(edges.get(0).oneCity);
		dfs(finalCities,city_edges,visited,city_index,back_city);
		finalCities.add(edges.get(0).oneCity);
		int Tourlength = 0;
		for(int i = 0; i < finalCities.size()-1;i++){
			Tourlength+= finalCities.get(i).distance(finalCities.get(i+1));
		}
		System.out.println("Tour length is "+Tourlength);
		return finalCities;
		
	}
	public static void dfs(ArrayList<City> finalCities,ArrayList<City>[]city_edges,boolean[]visited, int v, int back_city){
		visited[v] = true;
		//System.out.println(v);
		//System.out.println(city_edges[v]);
		for(int i = 0; i < city_edges[v].size();i++){
			//System.out.println(city_edges[v].get(i)+" is current try");
			//System.out.println("state of visited is "+visited[Integer.parseInt(city_edges[v].get(i).name)]);
			if(visited[Integer.parseInt(city_edges[v].get(i).name)] == false){
				//System.out.println(city_edges[v].get(i).name+" was chosen and is undiscovered");
				City w = city_edges[v].get(i);
				finalCities.add(w);
				//System.out.println("Calling dfs on city "+w);
				dfs(finalCities,city_edges,visited,Integer.parseInt(w.name),Integer.parseInt(city_edges[v].get(i).name));
			}
			
		}
	}

	
}
