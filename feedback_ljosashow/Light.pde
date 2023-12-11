
class Light {
  
  int light_type;
  
  int x_index, y_index;
  float x_position, y_position;
  color light_color = color(255);
  float light_strength = 0;
  float light_radius = 20;
  
  float fluorescent_light_width = 80;
  float fluorescent_light_height = 20;
  
  
  Light(int x_idx, int y_idx, int type){
    light_type = type;
    x_index = x_idx;
    y_index = y_idx;
    if(type == POINT_LIGHT){
      x_position = map(x_idx, 0, light_count_x-1, light_radius, width-light_radius);
      y_position = map(y_idx, 0, light_count_y-1, light_radius, height-light_radius);
    }
    if(type == FLUORESCENT_LIGHT){
      x_position = map(x_idx, 0, light_count_x-1, fluorescent_light_width, width-fluorescent_light_width);
      y_position = map(y_idx, 0, light_count_y-1, fluorescent_light_height, height-fluorescent_light_height);

    }
  }
  
  void show(){
    if(light_type == POINT_LIGHT){
      show_point_light();
    }
    if(light_type == FLUORESCENT_LIGHT){
      show_fluorescent_light();
    }
  }
  
  void show_point_light(){
    stroke(255,0.2);
    fill(255,global_light_strength * light_strength);
    
    ellipse(x_position,y_position,light_radius,light_radius);
    stroke(0);
    fill(0);
    textAlign(CENTER,CENTER);
    text(x_index,x_position,y_position);
  }
  
  void show_fluorescent_light(){
    stroke(255,0.2);
    fill(255,global_light_strength * light_strength);
    
    rect(x_position,y_position, fluorescent_light_width,fluorescent_light_height);
    stroke(0);
    fill(0);
    textAlign(CENTER,CENTER);
    text(x_index,x_position,y_position);
  }
  
  void update(){
    float x_dist = abs(x_position - mouseX);
    float y_dist = abs(y_position - mouseY);
    float distance_from_mouse = sqrt((x_dist * x_dist) + (y_dist * y_dist));
    light_strength = (255 - distance_from_mouse * 3);
  }
}
