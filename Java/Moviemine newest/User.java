import java.util.*;
public class User implements Comparable<User>{
	int idNumber;
	int movieID;
	int movieRating;
	ArrayList<Movie> movies = new ArrayList<Movie>();
	ArrayList<Movie> edited_movies = new ArrayList<Movie>();
	
	public User(int idNumber, int movieID, int movieRating){
		this.idNumber = idNumber;
		this.movieID = movieID;
		this.movieRating = movieRating;
		this.movies.add(new Movie(movieID,movieRating));
		
	}
	public User(int movieID,int movieRating){
		this.movies.add(new Movie(movieID,movieRating));
	}
	public String toString(){
		StringBuilder sb = new StringBuilder();
		for(Movie item:movies){
			sb.append(item);
		}
		return "User ID number is "+this.idNumber+"\n"+"Movie(s): "+sb.toString();
	}

	
	public int compareTo(User otheruser) {
		return this.idNumber - otheruser.idNumber;
	}
	public boolean hasSameNumbers(List<Integer> list) {
		int magic_number = list.size();
		
			for(int j = 0; j < list.size();j++){
				for(int i = 0; i < movies.size();i++){
					if(movies.get(i).movieID == list.get(j)){
						magic_number--;
						break;
				}
			}
		}
		if(magic_number == 0){
			//System.out.println("printed here! Increased the count of "+list);
			return true;
		}
		//System.out.println("printed false!" +magic_number);
		return false;
	}

}
