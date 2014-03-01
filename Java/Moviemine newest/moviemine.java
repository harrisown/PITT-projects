import java.io.*;
import java.util.*;
//support and confidence input between 0 and 1
//command line arguments

public class moviemine {
	static User blank = new User(0,0,0);
	static Movie blankMovie = new Movie(0,0);
	public static double MINSUP;
	public static double MINCONF;
	public static int MAXMOVIES;
	public static int num_users;
	public static String test = "";
	public static boolean go_to = false;
	public static void main(String[] args) {
		num_users = 0;
		int movie_number = 0;
		MINSUP = Double.parseDouble(args[1]);
		MINCONF = Double.parseDouble(args[3]);
		MAXMOVIES = Integer.parseInt(args[5]);
		String test_raw = args[6];
		test = "";
		test = test_raw.substring(1);
		if(test.equals("comb")){
			go_to = true;
		}
		
		if((MINSUP < 0 || MINSUP > 100)||(MINCONF < 0 || MINCONF > 100)||MAXMOVIES<0||test == null){
			System.out.println("Input variables aren't correct!");
			System.exit(0);
		}
		ArrayList<User> users = new ArrayList<User>(Collections.nCopies(945,blank));
		int[] user_exists = new int[945];
		try {
			FileInputStream fstream = new FileInputStream("src/u.data");//location of file in eclipse
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
				while((strLine = br.readLine()) != null){
					StringTokenizer tok = new StringTokenizer(strLine);
					String ID = tok.nextToken();
					int  userID = Integer.parseInt(ID);
					String MID = tok.nextToken();
					int movieID = Integer.parseInt(MID);
					String RANK = tok.nextToken();
					int movieRating = Integer.parseInt(RANK);
					Movie current_movie = new Movie(movieID , movieRating);
					
					if(user_exists[userID] == 0){
						num_users++;
						users.set(userID,new User(userID,movieID,movieRating));
						user_exists[userID] = 1;
					}else{
						users.get(userID).movies.add(current_movie);
					}

				}
			
				in.close();
		}catch(Exception e){
			if(e.getMessage()!= null){
				System.err.println("Error: " + e.getMessage());
			}
		}
		try {
			FileInputStream fstream = new FileInputStream("src/u.item");//location of file in eclipse
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
				while((strLine = br.readLine()) != null){
					movie_number++;
					StringTokenizer tok = new StringTokenizer(strLine,"|");
					String number = tok.nextToken();
					int  movieNumber = Integer.parseInt(number);
					String movieName = tok.nextToken();
					for(int i = 0; i < users.size(); i++){
						for(int j = 0; j < users.get(i).movies.size();j++){
							if(users.get(i).movies.get(j).movieID == movieNumber){
								users.get(i).movies.get(j).setName(movieName);
							}
						}
					}
				}
				
			
				in.close();
		}catch(Exception j){
			System.err.println("Error: " + j.getMessage());
		}
		
		//System.out.println("Num users is "+num_users);
		if(test.equals("pos")){
			for(int user_num = 1; user_num <num_users+1;user_num++){
				for(int usermovies = 0;usermovies< users.get(user_num).movies.size();usermovies++){
					if(users.get(user_num).movies.get(usermovies).ranking <=3){
						users.get(user_num).movies.remove(usermovies);
						usermovies--;
					}
				}
			}
			MINSUP*=num_users;
			MINCONF*=10;
			System.out.println(MINSUP);
			System.out.println(MINCONF);
			ArrayList<Movie> users_movies = new ArrayList<Movie>();
			Hashtable table = new Hashtable();
			Hashtable master_table = new Hashtable();
			for(int i = 1; i <= num_users;i++){
				for(int k = 0;k<users.get(i).movies.size();k++){
					ArrayList<Integer> add = new ArrayList<Integer>();
					add.add(users.get(i).movies.get(k).movieID);
					//System.out.println(users.get(i).movies.get(k).movieID+ " is the current movie from user "+i);
					
					//if(users.get(i).movies.get(k).ranking>3){
						if(table.containsKey(add)){
							int table_value = (Integer) table.get(add);
							table_value++;
							table.put(add, table_value);
							//System.out.println("added 1 to the existing");
						}else{
							table.put(add, 1);
							//System.out.println("added a new");
						}
					//}
				}
			}
			System.out.println(table);
			Iterator final_iter= table.keySet().iterator();
			while(final_iter.hasNext()){
					ArrayList<Integer> next = (ArrayList<Integer>) final_iter.next();
					//System.out.println(t.get(next));
					//System.out.println(MINSUP);
					if((Integer)table.get(next) < MINSUP){
						//System.out.println("hi");
						final_iter.remove();
					}
			}
			//System.out.println(table);
			master_table.putAll(table);
			//System.out.println(master_table);
			for(int i = 2; i <= MAXMOVIES;i++){
				table = find_combos(table,users,i);
				//System.out.println("table generated is "+table);
				if(!table.isEmpty()){
					master_table.putAll(table);	
				}
				//System.out.println(master_table);
			}
			//System.out.println(master_table+" is before print_up");
			printup(master_table);
			
			
		}
		if(test.equals("neg")){
			for(int user_num = 1; user_num <num_users+1;user_num++){
				for(int usermovies = 0;usermovies< users.get(user_num).movies.size();usermovies++){
					if(users.get(user_num).movies.get(usermovies).ranking >=3){
						users.get(user_num).movies.remove(usermovies);
						usermovies--;
					}
				}
			}
			MINSUP*=num_users;
			MINCONF*=10;
			ArrayList<Movie> users_movies = new ArrayList<Movie>();
			Hashtable table = new Hashtable();
			Hashtable master_table = new Hashtable();
			for(int i = 1; i <= num_users;i++){
				for(int k = 0;k<users.get(i).movies.size();k++){
					ArrayList<Integer> add = new ArrayList<Integer>();
					add.add(users.get(i).movies.get(k).movieID);
					//System.out.println(users.get(i).movies.get(k).movieID+ " is the current movie from user "+i);
					
					//if(users.get(i).movies.get(k).ranking>3){
						if(table.containsKey(add)){
							int table_value = (Integer) table.get(add);
							table_value++;
							table.put(add, table_value);
							//System.out.println("added 1 to the existing");
						}else{
							table.put(add, 1);
							//System.out.println("added a new");
						}
					//}
				}
			}
			//System.out.println(table);
			Iterator final_iter= table.keySet().iterator();
			while(final_iter.hasNext()){
					ArrayList<Integer> next = (ArrayList<Integer>) final_iter.next();
					//System.out.println(t.get(next));
					//System.out.println(MINSUP);
					if((Integer)table.get(next) < MINSUP){
						//System.out.println("hi");
						final_iter.remove();
					}
			}
			//System.out.println(table);
			master_table.putAll(table);
			//System.out.println(master_table);
			for(int i = 2; i <=MAXMOVIES;i++){
				table = find_combos(table,users,i);
				if(!table.isEmpty()){
					master_table.putAll(table);	
				}
			}
			//System.out.println(master_table+" is before print_up");
			printup(master_table);
			
			
		}
		if(test.equals("comb")){
			for(int user_num = 1; user_num <num_users+1;user_num++){
				for(int usermovies = 0;usermovies< users.get(user_num).movies.size();usermovies++){
					if(users.get(user_num).movies.get(usermovies).ranking >=3){
						users.get(user_num).movies.remove(usermovies);
						usermovies--;
					}
				}
			}
			MINSUP*=num_users;
			MINCONF*=10;
			ArrayList<Movie> users_movies = new ArrayList<Movie>();
			Hashtable table = new Hashtable();
			Hashtable master_table = new Hashtable();
			for(int i = 1; i <= num_users;i++){
				for(int k = 0;k<users.get(i).movies.size();k++){
					ArrayList<Integer> add = new ArrayList<Integer>();
					add.add(users.get(i).movies.get(k).movieID);
					//System.out.println(users.get(i).movies.get(k).movieID+ " is the current movie from user "+i);
					
					//if(users.get(i).movies.get(k).ranking>3){
						if(table.containsKey(add)){
							int table_value = (Integer) table.get(add);
							table_value++;
							table.put(add, table_value);
							//System.out.println("added 1 to the existing");
						}else{
							table.put(add, 1);
							//System.out.println("added a new");
						}
					//}
				}
			}
			//System.out.println(table);
			Iterator final_iter= table.keySet().iterator();
			while(final_iter.hasNext()){
					ArrayList<Integer> next = (ArrayList<Integer>) final_iter.next();
					//System.out.println(t.get(next));
					//System.out.println(MINSUP);
					if((Integer)table.get(next) < MINSUP){
						//System.out.println("hi");
						final_iter.remove();
					}
			}
			//System.out.println(table);
			master_table.putAll(table);
			//System.out.println(master_table);
			for(int i = 2; i <= MAXMOVIES;i++){
				table = find_combos(table,users,i);
				if(!table.isEmpty()){
					master_table.putAll(table);	
				}
			}
			//System.out.println(master_table+" is before print_up");
			test = "neg";
			printup(master_table);
			test = "comb2";
			
		}
		if(test.equals("comb2")){

		users = new ArrayList<User>(Collections.nCopies(945,blank));
		user_exists = new int[945];
		num_users = 0;

		try {
			FileInputStream fstream = new FileInputStream("src/u.data");//location of file in eclipse
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
				while((strLine = br.readLine()) != null){
					StringTokenizer tok = new StringTokenizer(strLine);
					String ID = tok.nextToken();
					int  userID = Integer.parseInt(ID);
					String MID = tok.nextToken();
					int movieID = Integer.parseInt(MID);
					String RANK = tok.nextToken();
					int movieRating = Integer.parseInt(RANK);
					Movie current_movie = new Movie(movieID , movieRating);
					
					if(user_exists[userID] == 0){
						num_users++;
						users.set(userID,new User(userID,movieID,movieRating));
						user_exists[userID] = 1;
					}else{
						users.get(userID).movies.add(current_movie);
					}

				}
			
				in.close();
		}catch(Exception e){
			if(e.getMessage()!= null){
				System.err.println("Error: " + e.getMessage());
			}
		}
		try {
			FileInputStream fstream = new FileInputStream("src/u.item");//location of file in eclipse
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
				while((strLine = br.readLine()) != null){
					movie_number++;
					StringTokenizer tok = new StringTokenizer(strLine,"|");
					String number = tok.nextToken();
					int  movieNumber = Integer.parseInt(number);
					String movieName = tok.nextToken();
					for(int i = 0; i < users.size(); i++){
						for(int j = 0; j < users.get(i).movies.size();j++){
							if(users.get(i).movies.get(j).movieID == movieNumber){
								users.get(i).movies.get(j).setName(movieName);
							}
						}
					}
				}
				
			
				in.close();
		}catch(Exception j){
			System.err.println("Error: " + j.getMessage());
		}
			for(int user_num = 1; user_num <num_users+1;user_num++){
				for(int usermovies = 0;usermovies< users.get(user_num).movies.size();usermovies++){
					if(users.get(user_num).movies.get(usermovies).ranking <=3){
						users.get(user_num).movies.remove(usermovies);
						usermovies--;
					}
				}
			}
			
			
			ArrayList<Movie> users_movies = new ArrayList<Movie>();
			Hashtable table = new Hashtable();
			Hashtable master_table = new Hashtable();
			for(int i = 1; i <= num_users;i++){
				for(int k = 0;k<users.get(i).movies.size();k++){
					ArrayList<Integer> add = new ArrayList<Integer>();
					add.add(users.get(i).movies.get(k).movieID);
					//System.out.println(users.get(i).movies.get(k).movieID+ " is the current movie from user "+i);
					
						if(table.containsKey(add)){
							int table_value = (Integer) table.get(add);
							table_value++;
							table.put(add, table_value);
							//System.out.println("added 1 to the existing");
						}else{
							table.put(add, 1);
							//System.out.println("added a new");
						}
					//}
				}
			}
			//System.out.println(table);
			Iterator final_iter= table.keySet().iterator();
			while(final_iter.hasNext()){
					ArrayList<Integer> next = (ArrayList<Integer>) final_iter.next();
					//System.out.println(t.get(next));
					//System.out.println(MINSUP);
					if((Integer)table.get(next) < MINSUP){
						//System.out.println("hi");
						final_iter.remove();
					}
			}
			//System.out.println(table);
			master_table.putAll(table);
			//System.out.println(master_table);
			for(int i = 2; i < MAXMOVIES;i++){
				table = find_combos(table,users,i);
				if(!table.isEmpty()){
					master_table.putAll(table);	
				}
			}
			//System.out.println(master_table+" is before print_up");
			test = "pos";
			printup(master_table);
			
			
		}
		
	}
	
	
	public static Hashtable find_combos(Hashtable table, ArrayList<User> users, int r_value){
		ArrayList<Integer> combinations = new ArrayList<Integer>();
		ArrayList<List<Integer>> combvalues = new ArrayList<List<Integer>>();
		//System.out.println("current hash "+table);
		Iterator iter = table.keySet().iterator();
		while(iter.hasNext()){
				ArrayList<Integer>hashvalue = (ArrayList<Integer>) iter.next();
				//System.out.println(hashvalue+"::value with support "+table.get(hashvalue));
				if((Integer)table.get(hashvalue) >= MINSUP){
					combinations.add((Integer) table.get(hashvalue));
					combvalues.add(hashvalue);
				}
		
		}
		//System.out.println("combinations that survive: "+combvalues);
		
		
		ArrayList<Integer>unique_combo_values = new ArrayList<Integer>();
		for(int i = 0; i < combvalues.size();i++){
			for(int k = 0; k < combvalues.get(i).size();k++){
				if(!unique_combo_values.contains(combvalues.get(i).get(k))){
					unique_combo_values.add(combvalues.get(i).get(k));
				}
			}
		}
		ArrayList<List<Integer>> new_combos = new ArrayList<List<Integer>>();
		new_combos = (ArrayList<List<Integer>>) combinations(unique_combo_values,r_value);
		//System.out.println("generated new combinations: "+new_combos);
		Hashtable t = new Hashtable();
		for(int j = 0; j < new_combos.size();j++){
			for(int i = 1; i <= num_users;i++){
				if(users.get(i).hasSameNumbers((new_combos.get(j)))){
					if(t.containsKey(new_combos.get(j))){
						int count = (Integer) t.get(new_combos.get(j));
						count++;
						t.put(new_combos.get(j), count);
						//System.out.println("added one to "+new_combos.get(j));
					}else{
						t.put(new_combos.get(j),1);
						//System.out.println("set to 1"+new_combos.get(j));
					}
				}
					
			}
		}
		//System.out.println("before weeding "+t);
		Iterator final_iter= t.keySet().iterator();
		while(final_iter.hasNext()){
				ArrayList<Integer>next = (ArrayList<Integer>) final_iter.next();
				//System.out.println("current support of "+ next+ " is "+t.get(next));
				//System.out.println(MINSUP);
				if((Integer)t.get(next) < MINSUP ||next.isEmpty()){
					//System.out.println("hi");
					final_iter.remove();
				}
		}
		
		return t;
	
	}
	public static void printup(Hashtable table){
		Hashtable new_table = new Hashtable();
		Hashtable confidences = new Hashtable();

		Iterator key_iter = table.keySet().iterator();
		while(key_iter.hasNext()){
			ArrayList<Integer>keys = (ArrayList<Integer>)key_iter.next();
			if(keys.size()>1){
				PermutationIterable <Integer> pi = new PermutationIterable <Integer> (keys);
				for (List <Integer> lc: pi){
					new_table.put(lc, table.get(keys));
				}
			}
		}
		//System.out.println(table+"!");
		table.putAll(new_table);
		//System.out.println(table);
		confidences = findConfidence(table);
		/*System.out.println(table);
		System.out.println("-------");
		System.out.println(confidences);*/
		
		Iterator key_iter2 = table.keySet().iterator();
		
		while(key_iter2.hasNext()){
			ArrayList<Integer> current_value = new ArrayList<Integer>();
			current_value = (ArrayList<Integer>) key_iter2.next();
			
		//System.out.println(MINSUP);
		//System.out.println(MINCONF);
		if(table.get(current_value)!= null && confidences.get(current_value)!= null){
			if((Integer)table.get(current_value) >= MINSUP){
				if(((Double)confidences.get(current_value)*10)>= MINCONF){
					System.out.println(test+":"+current_value +" is a valid rule with support "+table.get(current_value) +"(Minsupport was"+MINSUP+") and confidence"+(Double)confidences.get(current_value)*100+"%");
					
				}
			}
		}
		
		}
	}
    


public static Hashtable findConfidence(Hashtable table) {
    Hashtable confidences = new Hashtable();
    Iterator key_iter = table.keySet().iterator();
    while(key_iter.hasNext()){
    	//System.out.println("here");
    	ArrayList<Integer> combo = (ArrayList<Integer>) key_iter.next();
    	//System.out.println("current combo"+combo);
    		if(combo.size()>=2){
    			ArrayList<Integer>current_combo = new ArrayList<Integer>(combo.subList(0,combo.size()-1));
    			ArrayList<Integer>last_combo = new ArrayList<Integer>(combo.subList(combo.size()-1, combo.size()));
    			/*System.out.println(combo);
    			System.out.println(current_combo);
    			System.out.println(last_combo);
    			System.out.println(table.get(current_combo));*/
    		
    			if(table.get(current_combo)!= null){
    			//System.out.println("it contains!");
    				int first = (Integer)table.get(current_combo);
    				int second = (Integer)table.get(combo);
    				double dub_first = (double)first;
    				double dub_second = (double)second;
    				double combo_conf = dub_second/dub_first;
    				confidences.put(combo, combo_conf);
    				//System.out.println("combo:"+combo+" has the confience: "+combo_conf);
    			}
    		}
    	
    }
    //System.out.println(confidences+"O");

    return confidences;
}
   
	
		
static <T> List<List<T>> combinations( List<T> list, int n ){

    List<List<T>> result;

    if( list.size() <= n ){

        result = new ArrayList<List<T>>();
        result.add( new ArrayList<T>(list) );

    }else if( n <= 0 ){

        result = new ArrayList<List<T>>();
        result.add( new ArrayList<T>() );

    }else{

        List<T> sublist = list.subList( 1, list.size() );

        result = combinations( sublist, n );

        for( List<T> alist : combinations( sublist, n-1 ) ){
            List<T> thelist = new ArrayList<T>( alist );
            thelist.add( list.get(0) );
            result.add( thelist );
        }
    }

    return result;
}
	
}
	
	

			


		
	

	
		

