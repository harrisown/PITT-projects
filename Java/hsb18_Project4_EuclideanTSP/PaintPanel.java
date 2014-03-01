import java.awt.* ;
import java.awt.geom.Line2D;
import java.awt.geom.Point2D;
import java.util.*;

import javax.swing.* ;

public class PaintPanel extends JPanel {

  public Color BACKGROUND = Color.white ;
  public Color FOREGROUND;
  public boolean MST_paint;
  public boolean city_paint;
  public int width, height;
  public int box_x, box_y, box_width, box_height;
  public int city_x, city_y, othercity_x,othercity_y;
  ArrayList<Line> edges = new ArrayList<Line>();
  ArrayList<Line> walk = new ArrayList<Line>();
  private static class Line{
	  public int x; 
	  public int y;
	  public int xx;
	  public int yy;   
	    
	  public Line(int x, int y, int x2, int y2) {
	      this.x = x;
	      this.y = y;
	      this.xx = x2;
	      this.yy = y2;
	  }               
  }
  
  private static class city_draw{
	  public int x_cord;
	  public int y_cord;
	  
	  public city_draw(int x, int y){
		  this.x_cord = x;
		  this.y_cord = y;
	  }
  }
  
  public PaintPanel(int w, int h) {
    this.width = w ;
    this.height = h ;
    setPreferredSize(new Dimension(w,h)) ;
  }

  public void edge(int x, int y, int otherx, int othery){
	  city_x = x;
	  city_y = y;
	  othercity_x = otherx;
	  othercity_y = othery;
  }
  public void edge(City a, City b){
	  city_x = a.xCord;
	  city_y = a.yCord;
	  othercity_x = b.xCord;
	  othercity_y = b.yCord;
	  walk.add(new Line(city_x,city_y,othercity_x,othercity_y));
  }
  public void edge(Edge e){
	  city_x = e.oneCity.xCord;
	  city_y = e.oneCity.yCord;
	  othercity_x = e.otherCity.xCord;
	  othercity_y = e.otherCity.yCord;
	  edges.add(new Line(city_x,city_y,othercity_x,othercity_y));
	  
  }
  public void city(City city){
	  city_x = city.xCord;
	  city_y = city.yCord;
	  
	  
	  
  }

  public void paintComponent(Graphics g) {
	  //super.paintComponent(g) ;
	  if(TestMST.first == true){
	  for(int i = 0; i < edges.size();i++){
		  g.setColor(TestMST.FOREGROUND);
		  g.drawLine(edges.get(i).x, edges.get(i).y, edges.get(i).xx, edges.get(i).yy);
		  g.setColor(Color.magenta);
		  g.fillOval(edges.get(i).x-1, edges.get(i).y-1, 2, 2);
	  }
	  }else{
	  for(int i = 0 ; i < walk.size();i++){
		  g.setColor(TestMST.FOREGROUND);
		  g.drawLine(walk.get(i).x, walk.get(i).y, walk.get(i).xx, walk.get(i).yy);
	  }
	  }
	
    
	
    
  }

}