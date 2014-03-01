import java.awt.* ;
import java.util.*;

import javax.swing.* ;

public class TestMST {
	public static int WIDTH = 500, HEIGHT = 500, WAIT = 1000 ;
	public static Color FOREGROUND = Color.black;
	public static boolean first = true;
	public static ArrayList<City> cities = new ArrayList<City>();

	public static void main(String[] args) {
		int numCities = Integer.parseInt(args[0]);
		Random rand = new Random();
	
		
		
		JFrame frame = new JFrame("Demonstrate PaintPanel Object");
	    PaintPanel p = new PaintPanel(WIDTH,HEIGHT);
	    frame.getContentPane().add(p) ;
	    frame.pack();
	    frame.setVisible(true);
	    frame.repaint();
	    sleep(WAIT);
	    for(int i = 0 ; i < numCities; i++){
			cities.add(new City(""+i,rand.nextInt(500),rand.nextInt(500)));
			//System.out.println(cities.get(i));
	    }
	    
	    ArrayList<Edge> MST = EuclideanTSP.MST(cities);
	    
	    for(int i = 0; i < MST.size();i++){
	    	p.edge(MST.get(i));
	    	
	    }
	    p.repaint();
    	sleep(WAIT);
	   ArrayList<City> MSTtour = EuclideanTSP.Tour(MST);
	   FOREGROUND = Color.red;
	   first = false;
	   for(int i = 0; i < MSTtour.size()-1;i++){
		   p.edge(MSTtour.get(i), MSTtour.get(i+1));
		   sleep(WAIT);
		   p.repaint();
	   }
	   p.repaint();
	   sleep(WAIT);
	    
	}
	public static void sleep(long milliseconds) {
	    Date d ;
	    long start, now ;
	    d = new Date() ;
	    start = d.getTime() ;
	    do { d = new Date() ; now = d.getTime() ; } while ( (now - start) < milliseconds ) ;
	}

}
