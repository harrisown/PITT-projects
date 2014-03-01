import java.util.*;

public class HugeInteger implements Comparable<HugeInteger>, Cloneable{
	public static int DIGIT_OPERATIONS;
	public ArrayList<Integer> hi_list = new ArrayList<Integer>();

	public HugeInteger(String s) {
		for (int i = 0; i < s.length(); i++) {
			hi_list.add(s.charAt(i) - '0');

		}
	}
	public HugeInteger(HugeInteger h){
		this.hi_list = (ArrayList<Integer>) h.hi_list.clone();
		
		
	}
	public String toString(){		
		//System.out.println("Starting Print");
		//System.out.println("The current list is " + hi_list.toString());
		while(true){//remove zeroes at the front of a number
			if(this.hi_list.get(0).equals(0) && this.hi_list.size() > 1){
				this.hi_list.remove(0);
			}else{
				break;
			}
		}
		
			StringBuilder out = new StringBuilder();
			for (Object o : this.hi_list){
			  out.append(o.toString());
			}
			if(out.capacity() == 0){ // if array is empty, just make it 0
				out.append('0');
			}
			//System.out.println("List before exiting is " + hi_list.toString());
			//System.out.println("Exiting Print");
			return out.toString();
		
		
	}
	public void zero_out(HugeInteger o){
		while(o.hi_list.size() != this.hi_list.size()){
			if(o.hi_list.size() < this.hi_list.size()){
				o.hi_list.add(0,0);
			}else{
				this.hi_list.add(0,0);
			}
		}
		
	}
	public int compareTo(HugeInteger h) {
		zero_out(h);
		for(int i = 0; i< this.hi_list.size();i++){
			DIGIT_OPERATIONS++;
			if(this.hi_list.equals(h.hi_list)){
				return 0;
			}
			int this_int = this.hi_list.get(i);
			int h_int = h.hi_list.get(i);
			
				if(this_int > h_int){
					return 1;
				}
				if(this_int < h_int){
					return -1;
				}
		}
		return 0;
	}
	public HugeInteger add(HugeInteger h){
		zero_out(h);
		HugeInteger added_huge = new HugeInteger("");
		ArrayList<Integer> added_array = new ArrayList<Integer>();
		int carry_digit = 0;

		for(int i = this.hi_list.size() - 1; i >= 0; i--){
			int this_digit = this.hi_list.get(i);
			int h_digit = h.hi_list.get(i);
			int added_digit = 0;
			added_digit = this_digit + h_digit + carry_digit;
			DIGIT_OPERATIONS++;
			if(added_digit > 9){
				added_digit = Math.abs(10-added_digit);
				DIGIT_OPERATIONS++;
				carry_digit = 1;
			}else{
				carry_digit = 0;
			}
			added_array.add(0,added_digit);
			added_huge.hi_list = added_array;
		}
		if(carry_digit == 1){
			added_huge.hi_list.add(0,1);
			DIGIT_OPERATIONS++;
		}
		return added_huge;
	}
	public HugeInteger subtract(HugeInteger h){

		zero_out(h);
		HugeInteger subtracted_huge = new HugeInteger("");
		int subtracted_digit = 0;
		this.hi_list.set(0, this.hi_list.get(0) -1);
		//System.out.println(this + "should be -1");
		for(int i = 1; i < this.hi_list.size();i++){
			this.hi_list.set(i, this.hi_list.get(i) + 9);
			DIGIT_OPERATIONS++;
			//System.out.println(this + "plus 9 across the board");
		}
		for(int j = this.hi_list.size()-1; j>= 0; j--){
			subtracted_digit = this.hi_list.get(j) - h.hi_list.get(j);
			subtracted_huge.hi_list.add(0,subtracted_digit);
			DIGIT_OPERATIONS++;
		}
		subtracted_huge.hi_list.set(subtracted_huge.hi_list.size() -1, subtracted_huge.hi_list.get(subtracted_huge.hi_list.size()-1) + 1);
		for(int k = this.hi_list.size()-1; k>=0; k--){
			if(subtracted_huge.hi_list.get(k) >= 10){
				subtracted_huge.hi_list.set(k, subtracted_huge.hi_list.get(k) - 10);
				subtracted_huge.hi_list.set(k-1, subtracted_huge.hi_list.get(k-1) + 1);
				DIGIT_OPERATIONS+=2;
			}
		}
		return subtracted_huge;
	}
	public HugeInteger multiply(HugeInteger h){
		zero_out(h);
		HugeInteger multiplied_huge = new HugeInteger("");
		HugeInteger multiply_accumulator = new HugeInteger("");
		
		int carry_number = 0;
		int result_digit = 0;
		int shift_num = 0;
		
		for(int i = h.hi_list.size()-1; i >= 0; i--){
			int multiplier = h.hi_list.get(i);
			multiplied_huge.hi_list.clear();
			carry_number = 0;
			
			for(int j = this.hi_list.size()-1; j >=0; j--){
				int multiplied = this.hi_list.get(j);
				int result = multiplier*multiplied + carry_number;
				DIGIT_OPERATIONS++;
				if(result > 9){
					result_digit = result%10;
					carry_number = ((result - result_digit)%100)/10;
					multiplied_huge.hi_list.add(0,result_digit);					
				}else{
					result_digit = result;
					multiplied_huge.hi_list.add(0,result_digit);
					carry_number = 0;
				}
				
			}
			if(carry_number != 0){
				multiplied_huge.hi_list.add(0,carry_number);
			}
			//System.out.println("Huge before shifts is "+multiplied_huge);
			for(int l = 0; l < shift_num; l++){
				multiplied_huge.hi_list.add(0);
			}
			//System.out.println("That becomes "+multiplied_huge+ " after "+shift_num+ " shifts");
			multiply_accumulator = multiply_accumulator.add(multiplied_huge);
			//System.out.println("accumululator total is "+multiply_accumulator);
			shift_num++;
		}
		return multiply_accumulator;
	}
	public HugeInteger fastMultiply(HugeInteger h){
		zero_out(h);
		zero_out(this);
		boolean digs_odd = false;
		HugeInteger a_high = new HugeInteger(this);
		HugeInteger a_low = new HugeInteger(this);
		HugeInteger b_high = new HugeInteger(h);
		HugeInteger b_low = new HugeInteger (h);
		//System.out.println(a_high + " is a_high array(beginning)");
		//System.out.println(b_high + " is b_high array(beginning)");
		
		int digs = Math.max(this.hi_list.size(), h.hi_list.size());
		if(digs % 2 == 1){
			 digs_odd = true;
		}else{
			digs_odd = false;
		}
		if(digs <= 10){
			return this.multiply(h);
		}
		//System.out.println("digs before halving is "+digs);
		digs = (digs/2) + (digs %2);
		//System.out.println(digs+"!");
		
		for(int a_high_iterator = 0; a_high_iterator < digs; a_high_iterator++){
			//System.out.println(a_high_iterator + " is the current iteration out of "+digs);
			 a_high.hi_list.remove(a_high.hi_list.size()-1);
		}
		if(digs_odd){
			digs -=1;
			for(int a_low_iterator = 0; a_low_iterator < digs; a_low_iterator++){
				//System.out.println("iteration "+a_low_iterator + " out of "+digs);
				//System.out.println(a_low);
				a_low.hi_list.remove(0);
			}
			digs +=1;
		}else{
			for(int a_low_iterator = 0; a_low_iterator < digs; a_low_iterator++){
				a_low.hi_list.remove(0);
			}
		}
		
		// b
		for(int b_high_iterator = 0; b_high_iterator < digs; b_high_iterator++){
			 b_high.hi_list.remove(b_high.hi_list.size()-1);
		}
		if(digs_odd){
			digs-=1;
			for(int b_low_iterator = 0; b_low_iterator < digs; b_low_iterator++){
				b_low.hi_list.remove(0);
			}
			digs+=1;
		}else{
			for(int b_low_iterator = 0; b_low_iterator <digs; b_low_iterator++){
				b_low.hi_list.remove(0);
			}
		}
		
		HugeInteger b = new HugeInteger(a_high);
		//System.out.println(b + " is b (a_high)");
		HugeInteger a = new HugeInteger(a_low);
		//System.out.println(a + " is a (a_low)");
		HugeInteger d = new HugeInteger(b_high);
		//System.out.println(d + " is d (b_high)");
		HugeInteger c = new HugeInteger(b_low);
		//System.out.println(c + " is c (b_low)");
		//System.exit(0);
		HugeInteger ac = new HugeInteger(a.fastMultiply(c));
		//System.out.println(ac + " ac");
		DIGIT_OPERATIONS++;
		HugeInteger bd = new HugeInteger(b.fastMultiply(d));
		DIGIT_OPERATIONS++;
		//System.out.println(bd + "bd");
		HugeInteger abcd = new HugeInteger((a.add(b)).fastMultiply((c.add(d))));
		DIGIT_OPERATIONS++;
		HugeInteger inside = new HugeInteger(abcd.subtract(ac).subtract(bd));
		DIGIT_OPERATIONS++;
		for(int i = 0; i< digs;i++){
			inside.hi_list.add(0);
		}
		for(int i = 0; i < 2*digs;i++){
			bd.hi_list.add(0);
		}
		return ac.add(inside).add(bd);
		
		
	}
	
}
