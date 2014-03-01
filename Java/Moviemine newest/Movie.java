import java.util.*;
public class Movie {
	public ArrayList<Movie> all = new ArrayList<Movie>();
	public int movieID;
	public int ranking;
	public String name;
	public ArrayList<String> movieNames = new ArrayList<String>();
	public int mark;
	
	public Movie(int identity, int ranking){
		this.movieID = identity;
		this.ranking = ranking;
	}
	public void setName(String name){
		this.name = name;
	}
	public int compareTo(Movie othermovie){
		return this.movieID-othermovie.movieID;
	}
	public String toString(){
		return "\nMovieID:"+this.movieID+"\nMovie Ranking:"+this.ranking+"\nMovie Name:"+name;
	}
	
	
}
