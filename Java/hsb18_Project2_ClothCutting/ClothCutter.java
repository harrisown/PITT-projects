import java.util.ArrayList;
import java.util.Collections;

public class ClothCutter {

	public int width;
	public int height;
	public ArrayList<Pattern> patterns = new ArrayList<Pattern>();
	public Pattern best_pattern = new Pattern();
	public ArrayList<Pattern> cuts = new ArrayList<Pattern>();
	public int value;
	public ArrayList<Integer> possible_cuts = new ArrayList<Integer>();

	public ClothCutter(int width, int height, ArrayList<Pattern> patterns) {
		this.width = width;
		this.height = height;
		this.patterns = patterns;
		this.value = 0;
	}
	public ClothCutter(ClothCutter copied){
        this.width = copied.width;
        this.height = copied.height;
        this.value = copied.value;
    }
	public void optimize(){
	    this.optimize(new ArrayList<ClothCutter>());
	}
	public void optimize(ArrayList<ClothCutter>stored_cutters) {
		for (int j = 0; j < patterns.size(); j++) {
			if(patterns.get(j).width <= this.width && patterns.get(j).height <= this.height && patterns.get(j).value > best_pattern.value ){
				best_pattern = patterns.get(j);
			}
		}
			//System.out.println("Current pattern's is "+best_pattern.name);
			for (int i = 1; i < width; i++) {
				ClothCutter right = new ClothCutter(this.width - i,this.height, this.patterns);
				right = this.memo_store(right,stored_cutters);
				ClothCutter left = new ClothCutter(i, this.height,this.patterns);
				left = this.memo_store(left,stored_cutters);
				//System.out.println("right and left is "+(left.value + right.value));
				this.possible_cuts.add((left.value + right.value));
			}
			for (int k = 1;k < height; k++) {
				ClothCutter top = new ClothCutter(this.width,k, this.patterns);
				top = this.memo_store(top,stored_cutters);
				ClothCutter bottom = new ClothCutter(this.width,height - k, this.patterns);
				bottom = this.memo_store(bottom,stored_cutters);
				//System.out.println("top and bottom is "+(top.value + bottom.value));
				this.possible_cuts.add((top.value + bottom.value));
			}

		
		Collections.sort(possible_cuts,Collections.reverseOrder());
		//System.out.println("possible_cuts array is currently "+possible_cuts);
		if (possible_cuts.size() > 0) {
			//System.out.println("Apparently, the best possible cut's value is "+possible_cuts.get(0));
			if (possible_cuts.get(0) > best_pattern.value) {
				this.value = possible_cuts.get(0);
				cuts.add(best_pattern);
				return;
			} else {
				//System.out.println("The value of the pattern was returned1: "+best_pattern.value);
				this.value = best_pattern.value;
				
			}
		}else{
		//System.out.println("The value of the pattern was returned2: "+best_pattern.value);
		this.value = best_pattern.value;

		}

	}

	public int value(ClothCutter cutter) {
		return cutter.value;
	}
	public boolean equals(ClothCutter cutter){
	        if (this.height == cutter.height && this.width == cutter.width){
	            return true;
	        }
	        	return false;
	}
	public ClothCutter memo_store(ClothCutter cutter, ArrayList<ClothCutter> stored_cutters){
		boolean copy = false;
		for(int i = 0; i < stored_cutters.size(); i++){
			if(stored_cutters.get(i).equals(cutter)){
				//System.out.println("Found stored cut" + stored_cutters.get(i).width + ","+ stored_cutters.get(i).height);
				copy = true;
				cutter = new ClothCutter(stored_cutters.get(i));
				return cutter;
				
			}
		}
		if(!copy){
			//System.out.println("Storing a cut"+ cutter.width +"," + cutter.height);
			cutter.optimize(stored_cutters);
			stored_cutters.add(cutter);
			return cutter;
		}
		return cutter;
		
	}

}
