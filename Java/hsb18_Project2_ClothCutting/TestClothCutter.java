import java.util.*;
public class TestClothCutter {

	
	public static void main(String[] args) {
		 ArrayList<Pattern> patterns = new ArrayList<Pattern>() ;
		    patterns.add(new Pattern(2,2,1,"A")) ;
		    patterns.add(new Pattern(2,6,4,"B")) ;
		    patterns.add(new Pattern(4,2,3,"C")) ;
		    patterns.add(new Pattern(5,3,5,"D")) ;
		    int width = 100;
		    int height = 100;

		    ClothCutter cutter = new ClothCutter(width,height,patterns) ;
		    cutter.optimize() ;
		    System.out.println(cutter.value(cutter)) ;

	}

}
