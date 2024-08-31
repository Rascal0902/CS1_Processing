/***************************/
// 2023320123 박건호
// robocar (using maked compiler)
/***************************/

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 
import java.util.HashMap; 
import java.util.ArrayList; 
import java.util.LinkedList;
import java.util.Queue;
import java.util.Vector;
import java.io.*; 

import java.awt.Frame;
import processing.awt.PSurfaceAWT;
import processing.core.PApplet;
public class Robocar extends PApplet {
    int codelength=0;
    float ex=0,consolecheck=0;
    int oneloopcoordTrue=0;
    float velocityshowx=600,acclerationshowx=1100,timebooster=50,timedrift=0;
    Wheel c= new Wheel(0,0,0,10,20);
    Car cart = new Car(0,0,0);
    PFont myFont;
    String[] code= new String[10000];
    boolean oneloopretreived=true,oneloopsave=true,oneloopconsole=true;
    Queue<PVector> command = new LinkedList<PVector>();
    Coordinate video = new Coordinate(0,1,0,850,100);
    movingcoordinate carvideo = new movingcoordinate(0,1,0,850,100);
    MySystem system;

    public static void main(String args[]) {
        PApplet.main("Robocar");
    }
    public void settings() {size(1800,900);smooth();}
    public void setup() {setting();system= new TestSys();}
    public void draw() {display();system.display();}
    void sysinfo() {
     println();
     println("##########################################################################");
     println( "__SYS INFO :");
     println( "System     : " + System.getProperty("os.name") + "  " + System.getProperty("os.version") + "  " + System.getProperty("os.arch") );
     println( "JAVA       : " + System.getProperty("java.home")  + " rev: " +javaVersionName);
     //println( System.getProperty("java.class.path") );
     //println( "\n" + isGL() + "\n" );
     println( "OPENGL     : VENDOR " + PGraphicsOpenGL.OPENGL_VENDOR+" RENDERER " + PGraphicsOpenGL.OPENGL_RENDERER+" VERSION " + PGraphicsOpenGL.OPENGL_VERSION+" GLSL_VERSION: " + PGraphicsOpenGL.GLSL_VERSION);
     println( "user.home  : " + System.getProperty("user.home") );
     println( "user.dir   : " + System.getProperty("user.dir") );
     println( "user.name  : " + System.getProperty("user.name") );
     println( "sketchPath : " + sketchPath() );
     println( "dataPath   : " + dataPath("") );
     println( "dataFile   : " + dataFile("") );
     println( "frameRate  :  actual "+nf(frameRate, 0, 1));
     println( "canvas     : width "+width+" height "+height+" pix "+(width*height));
     println("##########################################################################");
     println();
     }
public class Car extends Carphysics{
  
  float x,y,z; //carvideo 기준 좌표
  float R=0,G=0,B=255; //216
  
  Car(float x,float y,float z){this.x=x;this.y=y;this.z=z; //바퀴
    for(int i=0;i<4;i++){
      if(i==0){carwheel[i]=new Wheel(x+140,y,z+320,20,100);}
      if(i==1){carwheel[i]=new Wheel(x+140,y,z-320,20,100);}
      if(i==2){carwheel[i]=new Wheel(x-140,y,z+320,20,100);}
      if(i==3){carwheel[i]=new Wheel(x-140,y,z-320,20,100);}
      carwheel[i].wheelcolor(125,125,125);}}
      
  void carshow(float alpha){
      for(int i=0;i<4;i++){carwheel[i].display(alpha);}
      carvideo.movingquad3D(x+160,y,z-200,x+160,y,z,x+160,y+160,z,x+160,y+160,z-200,R,G,B,video.size,3,alpha);//+x 뒷문
      carvideo.movingquad3D(x+160,y,z+200,x+160,y,z,x+160,y+160,z,x+160,y+160,z+200,R,G,B,video.size,3,alpha);//+x 앞문
      carvideo.movingquad3D(x-160,y,z-200,x-160,y,z,x-160,y+160,z,x-160,y+160,z-200,R,G,B,video.size,3,alpha);//-x 뒷문
      carvideo.movingquad3D(x-160,y,z+200,x-160,y,z,x-160,y+160,z,x-160,y+160,z+200,R,G,B,video.size,3,alpha);//-x 앞문
      carvideo.movingquad3D(x+160,y+120,z-200,x+160,y+120,z-440,x+160,y+160,z-440,x+160,y+160,z-200,R,G,B,video.size,3,alpha);//+x 뒷바퀴 위 
      carvideo.movingquad3D(x+160,y+120,z+200,x+160,y+120,z+440,x+160,y+160,z+440,x+160,y+160,z+200,R,G,B,video.size,3,alpha);//+x 앞바퀴 위 
      carvideo.movingquad3D(x-160,y+120,z-200,x-160,y+120,z-440,x-160,y+160,z-440,x-160,y+160,z-200,R,G,B,video.size,3,alpha);//-x 뒷바퀴 위 
      carvideo.movingquad3D(x-160,y+120,z+200,x-160,y+120,z+440,x-160,y+160,z+440,x-160,y+160,z+200,R,G,B,video.size,3,alpha);//-x 앞바퀴 위
      carvideo.movingquad3D(x+160,y,z-440,x+160,y+160,z-440,x+160,y+160,z-590,x+160,y,z-530,R,G,B,video.size,3,alpha);//+x 뒤쪽 팬더
      carvideo.movingquad3D(x-160,y,z-440,x-160,y+160,z-440,x-160,y+160,z-590,x-160,y,z-530,R,G,B,video.size,3,alpha);//-x 뒤쪽 팬더      
      carvideo.movingquad3D(x+160,y,z+440,x+160,y+160,z+440, x+100,y+140,z+480,x+100,y,z+480,R,G,B,video.size,3,alpha);//+x 앞쪽 팬더
      carvideo.movingquad3D(x-160,y,z+440,x-160,y+160,z+440, x-100,y+140,z+480,x-100,y,z+480,R,G,B,video.size,3,alpha);//-x 앞쪽 팬더      
      carvideo.movingBezier3Ddraw(x+160,y,z-440,x+160,y+120,z-440,x+160,y+120,z-320,R,G,B,video.size,alpha);//+x 뒷바퀴 뒤
      carvideo.movingBezier3Ddraw(x+160,y,z-200,x+160,y+120,z-200,x+160,y+120,z-320,R,G,B,video.size,alpha);//+x 뒷바퀴 앞
      carvideo.movingBezier3Ddraw(x+160,y,z+200,x+160,y+120,z+200,x+160,y+120,z+320,R,G,B,video.size,alpha);//+x 앞바퀴 뒤
      carvideo.movingBezier3Ddraw(x+160,y,z+440,x+160,y+120,z+440,x+160,y+120,z+320,R,G,B,video.size,alpha);//+x 앞바퀴 앞
      carvideo.movingBezier3Ddraw(x-160,y,z-440,x-160,y+120,z-440,x-160,y+120,z-320,R,G,B,video.size,alpha);//-x 뒷바퀴 뒤
      carvideo.movingBezier3Ddraw(x-160,y,z-200,x-160,y+120,z-200,x-160,y+120,z-320,R,G,B,video.size,alpha);//-x 뒷바퀴 앞
      carvideo.movingBezier3Ddraw(x-160,y,z+200,x-160,y+120,z+200,x-160,y+120,z+320,R,G,B,video.size,alpha);//-x 앞바퀴 뒤
      carvideo.movingBezier3Ddraw(x-160,y,z+440,x-160,y+120,z+440,x-160,y+120,z+320,R,G,B,video.size,alpha);//-x 앞바퀴 앞
      carvideo.movingquad3D(x+100,y+140,z+480,x+100,y,z+480,x-100,y,z+480,x-100,y+140,z+480,R,G,B,video.size,3,alpha);//+z 앞쪽 범퍼
      carvideo.movingquad3D(x+160,y+160,z-590,x+160,y,z-530,x-160,y,z-530,x-160,y+160,z-590,R,G,B,video.size,3,alpha);//-z 뒤쪽 범퍼
      carvideo.movingquad3D(x-160,y,z+200,x-160,y,z-200,x+160,y,z-200,x+160,y,z+200,R,G,B,video.size,3,alpha);//아래 중앙 덮개
      carvideo.movingquad3D(x+160,y,z+440,x+100,y,z+480,x-100,y,z+480,x-160,y,z+440,R,G,B,video.size,3,alpha);//+z 아래 앞쪽 중앙 덮개
      carvideo.movingquad3D(x+160,y,z-440,x+160,y,z-530,x-160,y,z-530,x-160,y,z-440,R,G,B,video.size,3,alpha);//-z 아래 뒤쪽 중앙 덮개
      carvideo.movingquad3D(x+100,y,z+480,x-100,y,z+480,x-100,y,z-530,x+100,y,z-530,R,G,B,video.size,3,5);//세로 아래 중앙 덮개
      carvideo.movingtriangle3D(x+160,y+160,z-590,x+80,y+320,z+40,x+160,y+160,z+440,R,G,B,video.size,3,alpha);//+x 삼각형
      carvideo.movingtriangle3D(x-160,y+160,z-590,x-80,y+320,z+40,x-160,y+160,z+440,R,G,B,video.size,3,alpha);//-x 삼각형
      carvideo.movingquad3D(x+80,y+320,z+40,x-80,y+320,z+40,x-160,y+160,z+440,x+160,y+160,z+440,255,0,0,video.size,0,alpha);//+z 위 뒷쪽 중앙 덮개 뒤
      carvideo.movingquad3D(x-100,y+140,z+480,x+100,y+140,z+480,x+160,y+160,z+440,x-160,y+160,z+440,255,0,0,video.size,0,alpha);//+z 위 뒷쪽 중앙 덮개 앞
      carvideo.movingquad3D(x+80,y+320,z+40,x-80,y+320,z+40,x-160,y+160,z-590,x+160,y+160,z-590,R,G,B,video.size,3,alpha);//-z 위 앞쪽 중앙 덮개
  }
}

public class Carphysics{
  
  PVector position= new PVector(0,-400,0);
  PVector velocity= new PVector(0,0,0.001);
  PVector accleration= new PVector(0,0,0);
  
  float k=0.2; //마찰력 비례 계수
  float oneloopbooster=0;
  
  Wheel[] carwheel = new Wheel[4]; 
  
  void update(){
    if(timedrift==0){if(1<=timebooster && timebooster<=30){k=0.05;}else{k=0.2;}}
    velocity.add(accleration);
    velocity.mult(1-k);
    carvideo.movingcheck3D(velocity.x,velocity.y,velocity.z,video.size);
    position.add(carvideo.A[0]-carvideo.movingx,carvideo.A[1]-carvideo.movingy,carvideo.A[2]-carvideo.movingz);
    carvideo.move(position.x,position.y,position.z);
    carvideo.setmovingplusangle(carvideo.w.y,0);
    timebooster++;
  }
  void goFoward(){
    accleration.add(0,0,40);
    update();
  }
  void goback(){
    accleration.add(new PVector(0,0,-40));
    update();
  }
  void goRight(){
    cart.frontwheelangle(20);
    carvideo.w.y=2*velocity.z/abs(velocity.z);
    update();
  }
  void goLeft(){
    cart.frontwheelangle(-20);
    carvideo.w.y=2*(-1)*velocity.z/abs(velocity.z); 
    update();
  }
  void godriftRight(){
    if(velocity.norm()>=50 && velocity.z>=0){velocity.moveceta(-4);timedrift++;k=0.1;}
    update();
  }
  void godriftLeft(){
    if(velocity.norm()>=50 && velocity.z>=0){velocity.moveceta(+4);timedrift++;k=0.1;}
    update();
  }
  void booster(){
    cart.frontwheelmove(10);
    if(oneloopbooster==0){velocity.add(new PVector(0,0,50));oneloopbooster=1;}
    update();
  }
  void stp(){
    velocity.mult(0.75);accleration=new PVector(0,0,0);
    update();
 }
  void nothing(){
    oneloopbooster=0;accleration=new PVector(0,0,0);carvideo.w.y=0;
    update();
  }
  void frontwheelangle(float angle){carwheel[0].angle=angle;  carwheel[2].angle=angle;}
  void frontwheelmove(float delta){carwheel[0].delta+=delta;  carwheel[2].delta+=delta;}
}

public class Wheel{
  
  float x,y,z,wheelwidth,r,Red,Green,Blue;
  
  float angle=0; // 회전 각
  float delta; // 바퀴 회전
  
  float[] B=new float[100];
  
  Wheel(){this.x=0;this.y=0;this.z=0;this.wheelwidth=10;this.r=20;this.delta=0;}
  
  Wheel(float x,float y,float z,float wheelwidth,float r){
  this.x=x;this.y=y;this.z=z;this.wheelwidth=wheelwidth;this.r=r;this.delta=0;}
  void locatechangewheel(float x,float y,float z){this.x=x;this.y=y;this.z=z;} //위치 설정
  void wheelcolor(float Red,float Green,float Blue){this.Red=Red; this.Green=Green; this.Blue=Blue;} //색상 설정
  void shiftangle(float shiftangle){   // 바퀴 자체 회전 //shiftangle++ -> -x축 방향 회전 
    this.angle=shiftangle;this.angle=constrain((int)this.angle,-50,50);}
  void movewheel(float movedelta){this.delta+=movedelta;}     // 바퀴 회전 //moveangle++ -> 뒤방향 회전 
  void display(float alpha){
    if(angle>0){angle-=5;}else if(angle<0){angle+=5;}
    fill(Red,Green,Blue,alpha);stroke(Red,Green,Blue,alpha);strokeWeight(0);
    beginShape(TRIANGLE_STRIP);
    for(int i=0;i<=360;i++){
      change3D(wheelwidth,r*sin(radians(delta+i)),r*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);
      change3D(-wheelwidth,r*sin(radians(delta+i)),r*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);}
    endShape();
     beginShape(TRIANGLE_STRIP);
    for(int i=0;i<=360;i++){
      change3D(wheelwidth,r*sin(radians(delta+i)),r*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);
      change3D(wheelwidth,r/2*sin(radians(delta+i)),r/2*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);}
    endShape();
     beginShape(TRIANGLE_STRIP);
    for(int i=0;i<=360;i++){
      change3D(-wheelwidth,r*sin(radians(delta+i)),r*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);
      change3D(-wheelwidth,r/2*sin(radians(delta+i)),r/2*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);}
    endShape();
    fill(Red,Green,Blue,1);stroke(Red,Green,Blue,1);
    beginShape(TRIANGLE_STRIP);
    for(int i=0;i<=360;i++){
      change3D(wheelwidth,r/2*sin(radians(delta+i)),r/2*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);
      change3D(-wheelwidth,r/2*sin(radians(delta+i)),r/2*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);}
    endShape();
    fill(50,50,50,alpha);stroke(50,50,50,alpha);
    beginShape(TRIANGLE_STRIP);
    for(int i=0;i<=360;i+=60){
      change3D(wheelwidth,r/3*sin(radians(delta+i)),r/3*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);
      change3D(wheelwidth,0,0);carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);}
    endShape();
    beginShape(TRIANGLE_STRIP);
    for(int i=0;i<=360;i+=60){
      change3D(-wheelwidth,r/3*sin(radians(delta+i)),r/3*cos(radians(delta+i)));carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);
      change3D(-wheelwidth,0,0);carvideo.movingvertex3D(x+B[0],y+B[1],z+B[2],video.size);}
    endShape();fill(0);stroke(0);strokeWeight(5);}
  void change3D(float a,float b,float c){ // 좌표계 이동
    B[0]=a*cos(radians(angle))-c*sin(radians(angle));B[1]=b;B[2]=a*sin(radians(angle))+c*cos(radians(angle));
  }
}
class PVector{
  float x,y,z;
  PVector(float x,float y){this.x=x;this.y=y;}
  PVector(float x,float y,float z){this.x=x;this.y=y;this.z=z;}
  float norm(PVector s){return sqrt(s.x*s.x+s.y*s.y+s.z*s.z);}
  float norm(){return sqrt(this.x*this.x+this.y*this.y+this.z*this.z);}
  void add(PVector s){this.x=this.x+s.x;this.y=this.y+s.y;this.z=this.z+s.z;} 
  void add(float x,float y,float z){this.x=this.x+x;this.y=this.y+y;this.z=this.z+z;} 
  void sub(PVector s){this.x=this.x-s.x;this.y=this.y-s.y;this.z=this.z-s.z;}
  void mult(float s){this.x=this.x*s;this.y=this.y*s;this.z=this.z*s;}
  void div(float s){this.x=this.x/s;this.y=this.y/s;this.z=this.z/s;}
  void normalize(){float norm=norm(this);this.x=this.x/norm;this.y=this.y/norm;this.z=this.z/norm;}
  void moveceta(float ceta){float x,z;
    x=this.x; z=this.z;
    this.x=x*cos(radians(ceta))-z*sin(radians(ceta));
    this.z=x*sin(radians(ceta))+z*cos(radians(ceta));} 
}
interface codeable{
  abstract void goAhead();
  abstract void goBack();
  abstract void goRight();
  abstract void goLeft();
  abstract void turnRight();
  abstract void turnLeft();
  abstract void goDriftRight();
  abstract void goDriftLeft();
  abstract void booster();
  abstract void goBreak();
  abstract void reset();
}

public class Code implements codeable{
  Code(){}
  
  void goAhead(){//'w',87
    W=255;
    cart.goFoward();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void goBack(){//'s',83
    S=255;  
    cart.goback();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void goRight(){//'w',87  'd',68
    W=255;D=255; 
    cart.goFoward();cart.nothing();
    cart.goRight();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void goLeft(){//'w',87 'a',65
    W=255;A=255;  
    cart.goFoward();cart.nothing();
    cart.goLeft();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void turnRight(){//'d',68
    D=255; 
    cart.goRight();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void turnLeft(){//'a',65
    A=255; 
    cart.goLeft();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void goDriftRight(){//'d',68 SHIFT,16
    DD=0;
    cart.goFoward();cart.goRight();
    cart.godriftRight();cart.nothing();
    return;}
    
  void goDriftLeft(){//'a',65 SHIFT,16
    DA=0;
    cart.goFoward();cart.goRight();
    cart.godriftLeft();cart.nothing();
    return;}

  void booster(){//' ',32
    space=255;
    cart.booster();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void goBreak(){//CTRL,17
    ct=255;
    cart.stp();cart.nothing();
    cart.k=0.2;timedrift=0;
    return;}
    
  void reset(){
    cart.position=new PVector(0,0,0);
    cart.k=0.2;timedrift=0;
    return;}
}
void showstring(float x,float y){
  float z=y;if(codelength==0){codelength=1;}
  textSize(30);fill(255);text("lines=",250,40);fill(255);text(codelength,320,40);
  textSize(20);
  for(int i=1;i<21;i++){strokeWeight(0.1);
    if(i==codelength){fill(255,0,0);stroke(255,0,0);fill(175);stroke(125);rect(50,100+30*(i-1),1700,30);fill(255,0,0);stroke(255,0,0);}
    else{fill(0);stroke(0);fill(255);fill(255);rect(50,100+30*(i-1),1700,30);fill(0);stroke(0);}
    strokeWeight(5);text(i,x-45,z-5);z+=30;}
   for(int i=1;i<min(20,code.length);i++){textAlign(LEFT);textSize(25);fill(0);stroke(0);text(code[i],x,y);y+=30;}
   textAlign(CENTER);
}

String[] retrieve;
void retreive(){
    for(int i=0;i<code.length;i++){code[i]="";}
    println("a");
    selectInput("Select a file to process:", "fileSelected");
    if(oneloopretreived){
    println("******************************");
    println("retrieve");
    println("******************************");
    oneloopretreived=false;}
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    println("User selected " + selection.getAbsolutePath());
    String res = selection.getAbsolutePath();
    String[] sp = split(res,'.');
    String[] sp2 = split(res,'\\');
    if(sp[sp.length-1].equals("txt")){
      retrieve = loadStrings(res);
       for(int i=0;i<retrieve.length;i++){
        code[i]=retrieve[i];
       }
       for(int i=retrieve.length;i<10000;i++){
        code[i]="";
       }
    }
    else{
      println("ERROR: Not type of image");      
    }
  }
}  

void savecode(){
    String savename = "textout";
    code[0]="#robocarfile #time: "+Integer.toString(year())+" / "+Integer.toString(month())+" / "+Integer.toString(day())+" / "+Integer.toString(hour())+" : "+Integer.toString(minute())+" : "+Integer.toString(second());
    saveStrings("data\\"+savename+".txt", code);
    if(oneloopsave){println("******************************");println("saved");println("******************************");oneloopsave=false;}
}

void commandout(){
  if(command.size()>0){
    Code com = new Code();
    if(command.peek().y<=0){command.remove();return;}
      command.peek().y--;
    if(command.peek().x==0){com.goAhead();}
    if(command.peek().x==1){com.goBack();}
    if(command.peek().x==2){com.goRight();}
    if(command.peek().x==3){com.goLeft();}
    if(command.peek().x==4){com.turnRight();}
    if(command.peek().x==5){com.turnLeft();}
    if(command.peek().x==6){com.goDriftRight();}
    if(command.peek().x==7){com.goDriftLeft();}
    if(command.peek().x==8){com.booster();}
    if(command.peek().x==9){com.goBreak();}
    if(command.peek().x==10){com.reset();}
  }
  return;
}

void console(){consolecheck=1;
  for(int line=1;line<10000;line++){ println(line,code[line]);
    String make="";float[] makefloat = new float[100]; 
    if((code[line].length()>=8)&&(code[line].substring(0,7)).equals("goAhead")==true){//goAhead(int time);
    make=code[line].substring(8,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(0,makefloat[0]));}
    
    else if((code[line].length()>=7)&&(code[line].substring(0,6)).equals("goBack")==true){//goBack(int time);
    make=code[line].substring(7,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(1,makefloat[0]));}
    
    else if((code[line].length()>=8)&&(code[line].substring(0,7)).equals("goRight")==true){//goRight(int time);
    make=code[line].substring(8,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(2,makefloat[0]));}
    
    else if((code[line].length()>=7)&&(code[line].substring(0,6)).equals("goLeft")==true){//goLeft(int time);
    make=code[line].substring(7,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(3,makefloat[0]));}
    
    else if((code[line].length()>=10)&&(code[line].substring(0,9)).equals("turnRight")==true){//turnRight(int time);
    make=code[line].substring(10,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(4,makefloat[0]));}
    
    else if((code[line].length()>=9)&&(code[line].substring(0,8)).equals("turnLeft")==true){//turnLeft(int time);
    make=code[line].substring(9,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(5,makefloat[0]));}
    
    else if((code[line].length()>=13)&&(code[line].substring(0,12)).equals("goDriftRight")==true){//goDriftRight(int time);
    make=code[line].substring(13,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(6,makefloat[0]));}
    
    else if((code[line].length()>=12)&&(code[line].substring(0,11)).equals("goDriftLeft")==true){//goDriftLeft(int time);
    make=code[line].substring(12,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(7,makefloat[0]));}
    
    else if((code[line].length()>=8)&&(code[line].substring(0,7)).equals("booster")==true){//booster(int time);
    make=code[line].substring(8,code[line].length()-1);String[] makestr = split(make,',');
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(8,makefloat[0]));}
    
    else if((code[line].length()>=8)&&(code[line].substring(0,7)).equals("goBreak")==true){//goBreak(int time);
    make=code[line].substring(8,code[line].length()-1);String[] makestr = split(make,',');//println(make);
    for(int i=0;i<1;i++){makefloat[i]=inttry(makestr[i]);}
    command.add(new PVector(9,makefloat[0]));}
    
    else if((code[line].length()>=6)&&(code[line].substring(0,5)).equals("reset")==true){//reset();
    command.add(new PVector(10,makefloat[0]));}
    
  }
  println("******************************");println("consoled");println("******************************");
}

float power(float x, int n) {if (n==0) {return 1;}else {int i;float sum=1;for (i=0; i<n; i++){sum*=x;}return sum;}}

float floattry(String str){
  float[] subfloat = new float[2];float ans;//소수점 아래 5자리 까지
  int now=0;subfloat[0]=0;subfloat[1]=0;String[] newfloat = split(str,'.');
  for(int i=0;i<2;i++){for(int j=0;j<newfloat[i].length();j++){
      if(newfloat[i].substring(j,j+1).equals("E")==true){
      if(newfloat[i].substring(j+1,j+2).equals("-")){
      ans=subfloat[0]+subfloat[1]/pow(10,j);
      ans/=power(10,inttry(newfloat[i].substring(j+2,newfloat[1].length())));return ans;}
      else{ ans=subfloat[0]+subfloat[1]/pow(10,j);
      ans*=power(10,inttry(newfloat[i].substring(j+1,newfloat[i].length())));return ans;}}
      if(newfloat[i].substring(j,j+1).equals("0")==true){now=0;}
      if(newfloat[i].substring(j,j+1).equals("1")==true){now=1;}
      if(newfloat[i].substring(j,j+1).equals("2")==true){now=2;}
      if(newfloat[i].substring(j,j+1).equals("3")==true){now=3;}
      if(newfloat[i].substring(j,j+1).equals("4")==true){now=4;}
      if(newfloat[i].substring(j,j+1).equals("5")==true){now=5;}
      if(newfloat[i].substring(j,j+1).equals("6")==true){now=6;}
      if(newfloat[i].substring(j,j+1).equals("7")==true){now=7;}
      if(newfloat[i].substring(j,j+1).equals("8")==true){now=8;}
      if(newfloat[i].substring(j,j+1).equals("9")==true){now=9;}
      subfloat[i]*=10;subfloat[i]+=now;}}ans=subfloat[0]+subfloat[1]/pow(10,newfloat[1].length());return ans;}
   
int inttry(String str){
  int ans=0,now=0;String[] newfloat = new String [2];newfloat[0]=str;//println(str);
  for(int i=0;i<1;i++){for(int j=0;j<newfloat[i].length();j++){
      if(newfloat[i].substring(j,j+1).equals("0")==true){now=0;}
      if(newfloat[i].substring(j,j+1).equals("1")==true){now=1;}
      if(newfloat[i].substring(j,j+1).equals("2")==true){now=2;}
      if(newfloat[i].substring(j,j+1).equals("3")==true){now=3;}
      if(newfloat[i].substring(j,j+1).equals("4")==true){now=4;}
      if(newfloat[i].substring(j,j+1).equals("5")==true){now=5;}
      if(newfloat[i].substring(j,j+1).equals("6")==true){now=6;}
      if(newfloat[i].substring(j,j+1).equals("7")==true){now=7;}
      if(newfloat[i].substring(j,j+1).equals("8")==true){now=8;}
      if(newfloat[i].substring(j,j+1).equals("9")==true){now=9;}
      ans*=10;ans+=now;}}return ans;}
public class Coordinate{
  
  float coordinateTRUE,size,coordinateBW,rangecover,coordinaterange,locatex,locatey;
  
  float ceta,pi;
  
  float[] A = new float[100];
  
  Coordinate(){}
  
  Coordinate(float coordinateTRUE,float size,float coordinateBW,float rangecover,float coordinaterange){
    this.coordinateTRUE=coordinateTRUE; this.size=size; this.coordinateBW=coordinateBW; this.rangecover=rangecover; this.coordinaterange=coordinaterange; }
    
  void locate(float locatex,float locatey){
    this.locatex=locatex; this.locatey=locatey;}
    
  void setangle(float ceta,float pi){
    this.ceta=ceta; this.pi=pi;}
    
  void mouseanglechange(float x,float y){
    if((x>=locatex-rangecover && x<=locatex+rangecover && y>=locatey-rangecover && y<=locatey+rangecover && mousePressed)
       && !((mouseX>=30)&&(mouseX<=130)&&(mouseY>=120)&&(mouseY<=150))
       && !((mouseX>=30)&&(mouseX<=130)&&(mouseY>=180)&&(mouseY<=210))
       && !((mouseX>=30)&&(mouseX<=130)&&(mouseY>=240)&&(mouseY<=270))
      ){
      ceta=map(x,locatex-rangecover,locatex+rangecover,0,360);pi=map(y,locatey-rangecover,locatey+rangecover,0,360);}}
      
  void coordTRUE(){
    if(coordinateTRUE==1){coordinateTRUE=0;}else{coordinateTRUE=1;}}
    
  void display(){
    fill(255);stroke(255);rect(locatex-rangecover,locatey-rangecover,2*rangecover,2*rangecover);
    strokeWeight(5);fill(0);
    if (coordinateTRUE==1) {
    line3D(0, 0, 0, coordinaterange, 0, 0, size, 255, 255*coordinateBW, 255*coordinateBW, 5 ,0);
    line3D(0, 0, 0, 0, coordinaterange, 0, size, 255*coordinateBW, 255, 255*coordinateBW, 5 ,0);
    line3D(0, 0, 0, 0, 0, coordinaterange, size, 255*coordinateBW, 255*coordinateBW, 255, 5 ,0);
    textSize(20);stroke(255);fill(255*coordinateBW);
    check3D(coordinaterange+10, 0, 0, size);       text("+x", locatex+A[0], locatey+A[1]);
    check3D(0, coordinaterange+10, 0, size);       text("+y", locatex+A[0], locatey+A[1]);
    check3D(0, 0, coordinaterange+10, size);       text("+z", locatex+A[0], locatey+A[1]);
    fill(0);stroke(0);}}
    
  void point3D(float x,float y,float z,float siz){if(siz==0){siz=size;}stroke(255*coordinateBW);
    check3D(x,y,z,siz);
    strokeWeight(5);point(locatex+A[0],locatey+A[1]);fill(0);stroke(0);strokeWeight(5);}
    
  void point3D_RGB(float x,float y,float z,float R,float G,float B,float st,float siz,float alpha){if(siz==0){siz=size;}
    check3D(x,y,z,siz);
    if(alpha==0){strokeWeight(st);stroke(R,G,B);point(locatex+A[0],locatey+A[1]);stroke(0);strokeWeight(5);}
    else{strokeWeight(st);stroke(R,G,B,alpha);point(locatex+A[0],locatey+A[1]);stroke(0);strokeWeight(5);}}
    
  void line3D(float x,float y,float z,float w,float m,float n,float siz,float R,float G,float B,float strokeweight,float alpha){if(siz==0){siz=size;}
    A[2]=check3Dx(x,y,z,siz);A[3]=check3Dy(x,y,z,siz);
    A[4]=check3Dx(w,m,n,siz);A[5]=check3Dy(w,m,n,siz);
    if(alpha==0){strokeWeight(strokeweight);stroke(R,G,B);line(locatex+A[2],locatey+A[3],locatex+A[4],locatey+A[5]);stroke(0);strokeWeight(5);}
    else{strokeWeight(strokeweight);stroke(R,G,B,alpha);line(locatex+A[2],locatey+A[3],locatex+A[4],locatey+A[5]);stroke(0);strokeWeight(5);}}
    
  /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
  void check3D(float x,float y,float z,float siz){if(siz==0){siz=size;}
    A[0]=check3Dx(x,y,z,siz);A[1]=check3Dy(x,y,z,siz);}
    
  float check3Dx(float x,float y,float z,float siz){if(siz==0){siz=size;}
  return (x*cos(radians(ceta))-z*sin(radians(ceta)))*siz;}
  
  float check3Dy(float x,float y,float z,float siz){if(siz==0){siz=size;}
  return (y*cos(radians(pi))-x*sin(radians(pi))*sin(radians(ceta))-z*cos(radians(ceta))*sin(radians(pi)))*siz;}
  
  float check3Dz(float x,float y,float z,float siz){if(siz==0){siz=size;}
  return (x*cos(radians(pi))*sin(radians(ceta))+y*sin(radians(pi))+z*cos(radians(ceta))*cos(radians(pi)))*siz;}
  
  /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
  void quad3D(float x1,float y1,float z1,float x2,float y2,float z2,float x3,float y3,float z3,float x4,float y4,float z4,float R,float G,float B,float siz,float strokeweight,float alpha){
    A[0]=check3Dx(x1,y1,z1,siz);A[1]=check3Dy(x1,y1,z1,siz);
    A[2]=check3Dx(x2,y2,z2,siz);A[3]=check3Dy(x2,y2,z2,siz);
    A[4]=check3Dx(x3,y3,z3,siz);A[5]=check3Dy(x3,y3,z3,siz);
    A[6]=check3Dx(x4,y4,z4,siz);A[7]=check3Dy(x4,y4,z4,siz);
    if(alpha==0){fill(R,G,B);stroke(R,G,B);}else{fill(R,G,B,alpha);stroke(R,G,B,alpha);}strokeWeight(strokeweight);
    beginShape();
    vertex(locatex+A[0],locatey+A[1]);
    vertex(locatex+A[2],locatey+A[3]);
    vertex(locatex+A[4],locatey+A[5]);
    vertex(locatex+A[6],locatey+A[7]);
    endShape(CLOSE);
    strokeWeight(5);fill(0);stroke(0);}
    
  void grid3D(float x1,float y1,float z1,float x2,float y2,float z2,float x3,float y3,float z3,float x4,float y4,float z4,float R,float G,float B,float siz,float strokeweight,float alpha,float gap){
    quad3D(x1,y1,z1,x2,y2,z2,x3,y3,z3,x4,y4,z4,R,G,B,siz,strokeweight,alpha);
    for(int i=0;i<=abs(x4-x1)/gap;i++){line3D(x1+i*gap,y1,z1,x2+i*gap,y2,z2,siz,R,G,B,5,30);}
    for(int i=0;i<=abs(z2-z1)/gap;i++){line3D(x1,y1,z1+i*gap,x4,y4,z4+i*gap,siz,R,G,B,5,30);}}
  void triangle3D(float x1,float y1,float z1,float x2,float y2,float z2,float x3,float y3,float z3,float R,float G,float B,float siz,float strokeweight,float alpha){
    A[0]=check3Dx(x1,y1,z1,siz);A[1]=check3Dy(x1,y1,z1,siz);
    A[2]=check3Dx(x2,y2,z2,siz);A[3]=check3Dy(x2,y2,z2,siz);
    A[4]=check3Dx(x3,y3,z3,siz);A[5]=check3Dy(x3,y3,z3,siz);
    if(alpha==0){fill(R,G,B);stroke(R,G,B);}else{fill(R,G,B,alpha);stroke(R,G,B,alpha);}
    strokeWeight(strokeweight);
    beginShape();
    vertex(locatex+A[0],locatey+A[1]);
    vertex(locatex+A[2],locatey+A[3]);
    vertex(locatex+A[4],locatey+A[5]);
    endShape(CLOSE);strokeWeight(5);fill(0);stroke(0);}
    
  void Bezier3Ddraw(float x0,float y0,float z0,float x1,float y1,float z1,float x2,float y2,float z2,float R,float G,float B,float siz,float alpha){if(siz==0){siz=size;}
  float z,w,k,t=0;
  if(alpha==0){strokeWeight(0);stroke(R,G,B);fill(R,G,B);}else{strokeWeight(0);stroke(R,G,B,alpha);fill(R,G,B,alpha);}
  beginShape();
  check3D(x1,y1,z1,siz);vertex(locatex+A[0],locatey+A[1]);
  for(t=0;t<=1;t+=0.005){z=t*t*x0+2*t*(1-t)*x1+(1-t)*(1-t)*x2;w=t*t*y0+2*t*(1-t)*y1+(1-t)*(1-t)*y2;k=t*t*z0+2*t*(1-t)*z1+(1-t)*(1-t)*z2;
  check3D(z,w,k,siz);   vertex(locatex+A[0],locatey+A[1]);}
  endShape();stroke(0);fill(0);}
  
  void vertex3D(float x,float y,float z,float siz){
    check3D(x,y,z,siz);vertex(locatex+A[0],locatey+A[1]);}
}
abstract class MySystem{
    KeyboardManager keyboardManager = new KeyboardManager();
    MouseManager mouseManager = new MouseManager();
    MySystem(){}
    abstract public void init();
    abstract public void display();  
}

class TestSys extends MySystem{
    char c;  
    TestSys(){super();init();}
    public void init(){c='f';}
    public void display(){
       strokeWeight(2);fill(255);
       ellipseMode(CENTER);
       if(mouseManager.getButtonPressed(0)){fill(255,0,0); }
       if(mouseManager.getButtonPressed(1)){fill(0,255,0); }
       if(mouseManager.getButtonPressed(2)){fill(0,0,255); }
       ellipse(mouseManager.getMouseLocation().x,mouseManager.getMouseLocation().y,10,10);
       strokeWeight(5);}
}

class KeyboardManager{
  private static final int keyNum = 60;
   private boolean[] keyState = new boolean[keyNum]; //a~z: 0~25, 0~9: 26,35, ' '=36, 'ENTER'= 37, arrow lurd: 38~41, shift,ctrl,alt: 42~44
   KeyboardManager(){for(int i=0;i<keyNum;i++){keyState[i] = false;}}
   public void onKeyPress(char k,int kc){if(calKey(k,kc)==-1)return;keyState[calKey(k,kc)] = true;}
   public void onKeyRelease(char k,int kc){if(calKey(k,kc)==-1)return;keyState[calKey(k,kc)] = false;}
   public boolean isPressed(int k){return keyState[calKey((char)CODED,k)];}
   public boolean isPressed(char k){return keyState[calKey(k,0)];}
   public boolean isPressed(){
     boolean t = false;
     for(int i=0;i<keyNum;i++){t = t|keyState[i];}
     return t; }
   private int calKey(char k,int kc){
     if(k-'a'>=0&&k-'z'<=0){return k-'a';}
     else if(k-'A'>=0&&k-'Z'<=0){return k-'A';}
     else if(k-'0'>=0&&k-'9'<=0){return k-'0'+'z'-'a'+1;}
     else if(k==' '){return  36;}
     else if(k=='\n'){return  37;}
     else if(k==CODED){
         if(kc-LEFT>=0&&38+kc-LEFT<=41){return 38+kc-LEFT;}
         else if(kc-SHIFT>=0&&kc-SHIFT+42<=44){return 42+kc-SHIFT;}}
     else if(k==27){return  45;}//esc
     else{switch(k){case '-':case '_':return 46;
                    case '=':case '+':return 47;
                    case '{':case '[':return 48;
                    case ']':case '}':return 49;
                    case ';':case ':':return 50;
                    case '\'':case '"':return 51;
                    case ',':case '<':return 52;
                    case '.':case '>':return 53;
                    case '?':case '/':return 54;}}
     return -1;}
}

class MouseManager{
    private int x,y;
    private boolean[] button = new boolean[3]; //left = 0, right = 1, center = 2
    MouseManager(){button[0] = false;button[1] = false;x = 0;y = 0;}
    MouseManager(int tx,int ty){x = tx;y = ty;button[0] = false;button[1] = false;}
   public void onMousePressed(int tx,int ty,int b1){
    x = tx;y = ty;
    if(b1==37){button[0] = true;}
    else if(b1==39){button[1] = true;}
    else if(b1==3){button[2] = true;}}
   public void onMouseReleased(int tx,int ty,int b1){
    x = tx;y = ty;
    if(b1==37){button[0] = false;}
    else if(b1==39){button[1] = false;}
    else if(b1==3){button[2] = false;}} 
   public void onMouseMoved(int tx,int ty){
      x = tx;y = ty;}
   public PVector getMouseLocation(){
      return new PVector(x,y); }
   public boolean getButtonPressed(int b){
      return button[b]; }
}

void keyPressed(){
if(consolecheck==0){system.keyboardManager.onKeyPress(key,keyCode);}

if(ex==0){
  if(key==TAB){println();println("movable");println();consolecheck=0;}
}

if(ex==1){
  if(codelength<1){codelength=1;}
  if(key==TAB){for(int i=1;i<20;i++){code[i]="";codelength=1;}consolecheck=0;}
  else if(key==BACKSPACE){if(code[codelength].length()!=0)code[codelength]=code[codelength].substring(0,code[codelength].length()-1);}
  else if(key==DELETE){code[codelength]="";}
  else if(keyCode==UP){codelength--;}
  else if(((key==ENTER)||(keyCode==DOWN))&&(codelength<=19)){codelength++;}
  else{if(key!=CODED){code[codelength]=code[codelength]+key;}}
}

}

void keyReleased(){if(consolecheck==0){system.keyboardManager.onKeyRelease(key,keyCode)/*;println(key,keyCode)*/;}}

void mousePressed(){system.mouseManager.onMousePressed(mouseX,mouseY,mouseButton); }

void mouseReleased(){system.mouseManager.onMouseReleased(mouseX,mouseY,mouseButton); }

void mouseMoved(){system.mouseManager.onMouseMoved(mouseX,mouseY);}

void mouseDragged(){system.mouseManager.onMouseMoved(mouseX,mouseY);}

void mouseWheel(MouseEvent event) {
  if (video.size>=0.1) {float e = event.getCount()*0.1;video.size-=e;
  if(video.size<0.1){video.size=0.1;}}else{video.size=0.1;}
}
public class movingcoordinate extends Coordinate{// (0,0,0) 기준 movingceta movingpi만큼 회전한걸 그린후 *(movingx,y,z)으로 이동

   float movingx,movingy,movingz;
   
   PVector w=new PVector(0,0,0);
   
   float movingceta,movingpi; //movingceta ++ -> 밖으로 moving pi++ -> 위로
   
  movingcoordinate(float coordinateTRUE,float size,float coordinateBW,float rangecover,float coordinaterange){
    super(coordinateTRUE,size,coordinateBW,rangecover,coordinaterange);}
    
  void move(float movingx,float movingy,float movingz){
     this.movingx=movingx;this.movingy=movingy;this.movingz=movingz;}
     
  void setmovingangle(float movingceta,float movingpi){
    this.movingceta=movingceta; this.movingpi=movingpi;}
    
  void setmovingplusangle(float movingceta,float movingpi){
    this.movingceta+=movingceta; this.movingpi+=movingpi;}
    
  void movingdisplay(){
    strokeWeight(5);fill(0);
    if (coordinateTRUE==1) {
    movingline3D(0, 0, 0, coordinaterange, 0, 0, video.size, 255, 255, 255*coordinateBW, 5 ,0); //노
    movingline3D(0, 0, 0, 0, coordinaterange, 0, video.size, 255*coordinateBW, 255, 255, 5 ,0); //청
    movingline3D(0, 0, 0, 0, 0, coordinaterange, video.size, 255, 255*coordinateBW, 255, 5 ,0); //보
    textSize(20);stroke(255);fill(255*coordinateBW);
    fill(0);stroke(0);
    movingcheck3D(coordinaterange+10, 0, 0, size);  check3D(A[0],A[1],A[2],video.size); text("+x", locatex+A[0], locatey+A[1]);
    movingcheck3D(0, coordinaterange+10, 0, size);  check3D(A[0],A[1],A[2],video.size); text("+y", locatex+A[0], locatey+A[1]);
    movingcheck3D(0, 0, coordinaterange+10, size);  check3D(A[0],A[1],A[2],video.size); text("+z", locatex+A[0], locatey+A[1]);}
  }
  
  void movingpoint3D(float x,float y,float z,float siz){if(siz==0){siz=size;}stroke(255*coordinateBW);
    A[0]=movingcheck3Dx(x,y,z,siz);A[1]=movingcheck3Dy(x,y,z,siz);A[2]=movingcheck3Dz(x,y,z,siz);
    video.point3D(A[0],A[1],A[2],siz);}
    
  void movingpoint3D_RGB(float x,float y,float z,float R,float G,float B,float st,float siz,float alpha){if(siz==0){siz=size;}
    A[0]=movingcheck3Dx(x,y,z,siz);A[1]=movingcheck3Dy(x,y,z,siz);A[2]=movingcheck3Dz(x,y,z,siz);
    video.point3D_RGB(A[0],A[1],A[2],R,G,B,st,siz,alpha);}
    
  void movingline3D(float x,float y,float z,float w,float m,float n,float siz,float R,float G,float B,float strokeweight,float alpha){if(siz==0){siz=size;}
    A[0]=movingcheck3Dx(x,y,z,siz);A[1]=movingcheck3Dy(x,y,z,siz);A[2]=movingcheck3Dz(x,y,z,siz);
    A[3]=movingcheck3Dx(w,m,n,siz);A[4]=movingcheck3Dy(w,m,n,siz);A[5]=movingcheck3Dz(w,m,n,siz);
    video.line3D(A[0],A[1],A[2],A[3],A[4],A[5],siz,R,G,B,strokeweight,alpha);}
    
    /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
    
  void movingcheck3D(float x,float y,float z,float siz){if(siz==0){siz=size;}
    A[0]=movingcheck3Dx(x,y,z,siz);A[1]=movingcheck3Dy(x,y,z,siz);A[2]=movingcheck3Dz(x,y,z,siz);}
    
  float movingcheck3Dx(float x,float y,float z,float siz){if(siz==0){siz=size;}
  return x*cos(radians(movingceta))-z*sin(radians(movingceta))+movingx;}
  
  float movingcheck3Dy(float x,float y,float z,float siz){if(siz==0){siz=size;}
  return y*cos(radians(movingpi))-x*sin(radians(movingpi))*sin(radians(movingceta))-z*cos(radians(movingceta))*sin(radians(movingpi))+movingy;}
  
  float movingcheck3Dz(float x,float y,float z,float siz){if(siz==0){siz=size;}
  return x*cos(radians(movingpi))*sin(radians(movingceta))+y*sin(radians(movingpi))+z*cos(radians(movingceta))*cos(radians(movingpi))+movingz;}
  
   /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/
   
  void movingquad3D(float x1,float y1,float z1,float x2,float y2,float z2,float x3,float y3,float z3,float x4,float y4,float z4,float R,float G,float B,float siz,float strokeweight,float alpha){
    A[0]=movingcheck3Dx(x1,y1,z1,siz);A[1]=movingcheck3Dy(x1,y1,z1,siz);A[2]=movingcheck3Dz(x1,y1,z1,siz);
    A[3]=movingcheck3Dx(x2,y2,z2,siz);A[4]=movingcheck3Dy(x2,y2,z2,siz);A[5]=movingcheck3Dz(x2,y2,z2,siz);
    A[6]=movingcheck3Dx(x3,y3,z3,siz);A[7]=movingcheck3Dy(x3,y3,z3,siz);A[8]=movingcheck3Dz(x3,y3,z3,siz);
    A[9]=movingcheck3Dx(x4,y4,z4,siz);A[10]=movingcheck3Dy(x4,y4,z4,siz);A[11]=movingcheck3Dz(x4,y4,z4,siz);
    video.quad3D(A[0],A[1],A[2],A[3],A[4],A[5],A[6],A[7],A[8],A[9],A[10],A[11],R,G,B,siz,strokeweight,alpha);}
    
  void movingtriangle3D(float x1,float y1,float z1,float x2,float y2,float z2,float x3,float y3,float z3,float R,float G,float B,float siz,float strokeweight,float alpha){
    A[0]=movingcheck3Dx(x1,y1,z1,siz);A[1]=movingcheck3Dy(x1,y1,z1,siz);A[2]=movingcheck3Dz(x1,y1,z1,siz);
    A[3]=movingcheck3Dx(x2,y2,z2,siz);A[4]=movingcheck3Dy(x2,y2,z2,siz);A[5]=movingcheck3Dz(x2,y2,z2,siz);
    A[6]=movingcheck3Dx(x3,y3,z3,siz);A[7]=movingcheck3Dy(x3,y3,z3,siz);A[8]=movingcheck3Dz(x3,y3,z3,siz);
    video.triangle3D(A[0],A[1],A[2],A[3],A[4],A[5],A[6],A[7],A[8],R,G,B,siz,strokeweight,alpha);}
    
  void movingBezier3Ddraw(float x1,float y1,float z1,float x2,float y2,float z2,float x3,float y3,float z3,float R,float G,float B,float siz,float alpha){if(siz==0){siz=size;}
    A[0]=movingcheck3Dx(x1,y1,z1,siz);A[1]=movingcheck3Dy(x1,y1,z1,siz);A[2]=movingcheck3Dz(x1,y1,z1,siz);
    A[3]=movingcheck3Dx(x2,y2,z2,siz);A[4]=movingcheck3Dy(x2,y2,z2,siz);A[5]=movingcheck3Dz(x2,y2,z2,siz);
    A[6]=movingcheck3Dx(x3,y3,z3,siz);A[7]=movingcheck3Dy(x3,y3,z3,siz);A[8]=movingcheck3Dz(x3,y3,z3,siz);
    video.Bezier3Ddraw(A[0],A[1],A[2],A[3],A[4],A[5],A[6],A[7],A[8],R,G,B,siz,alpha);}
    
  void movingvertex3D(float x,float y,float z,float siz){if(siz==0){siz=size;}
    A[0]=movingcheck3Dx(x,y,z,siz);
    A[1]=movingcheck3Dy(x,y,z,siz);
    A[2]=movingcheck3Dz(x,y,z,siz);
    vertex3D(A[0],A[1],A[2],siz);}
    
}
void setting(){
  for(int i=0;i<code.length;i++){code[i]="";}
  textAlign(CENTER);myFont = createFont("바탕체", 32);textFont(myFont);
  video.locate(900,450);video.setangle(150,160);video.size=0.1;
  sysinfo();
}

void display(){
  if(ex==0){
  background(255);
  video.mouseanglechange(mouseX,mouseY);
  A=0;W=0;S=0;D=0;ct=0;DA=1;DD=1;space=0;nothingPressed=1;oneloopw=0;
  coordinateupdate();
  cart.update();
  video.display();
  video.grid3D(-10000,-500,-10000,-10000,-500,10000,10000,-500,10000,10000,-500,-10000,0,255,0,video.size,0,30,1000);
  carvideo.movingdisplay();
  cart.carshow(30);
  window0();
  arrowcheck0();
  }
  if(ex==1){
    background(255);
    stroke(0);fill(0);rect(0,0,width,50);
    A=0;W=0;S=0;D=0;ct=0;DA=1;DD=1;space=0;nothingPressed=1;oneloopw=0;
    window1();
    arrowcheck1();
  }
}

void window0(){
   //fill(0);stroke(0);rect(0,700,400,200);
   if(key==TAB && keyPressed){if(oneloopcoordTrue==0){video.coordTRUE();carvideo.coordTRUE();oneloopcoordTrue=1;}}else{oneloopcoordTrue=0;}
   textSize(20);text("ceta: "+video.ceta,80,30);text("pi: "+video.pi,80,60);text("size: "+video.size,80,90);
   stroke(#F203FF); fill(#F203FF); rect(30,120,100,30);
   stroke(0); fill(0); textSize(20);text("compiler",80,142);
   if ((mouseButton==LEFT)&&(mouseX>=30)&&(mouseX<=130)&&(mouseY>=120)&&(mouseY<=150)) {ex=1;}
   if(consolecheck==0){stroke(0); fill(0);}else{stroke(0);fill(255);} rect(30,180,100,30);
   if(consolecheck==0){stroke(0); fill(255);}else{stroke(0);fill(0);} textSize(20);text("console",80,202);
   if ((mouseButton==LEFT)&&(mouseX>=30)&&(mouseX<=130)&&(mouseY>=180)&&(mouseY<=210)) {if(oneloopconsole){oneloopconsole=false;console();}}else{oneloopconsole=true;}
   if(consolecheck==1){
     commandout();
   }
   fill(0);stroke(0);textSize(20);text("Robocar by 23학번 박건호",1650,880);fill(0);stroke(0);
}
 
void window1(){//compiler
  textSize(30);fill(255);stroke(255);text("Compiler",100,40);
  stroke(255); fill(255); rect(width-40,10,30,30);
  stroke(0); fill(0); textSize(20);text("X",width-25,32);
  if ((mouseButton==LEFT)&&(mouseX>=width-40)&&(mouseX<=width-10)&&(mouseY>=10)&&(mouseY<=40)) {ex=0;}
  fill(255);strokeWeight(5);rect(50,100,1700,600);
  showstring(60, 125);
  fill(255);stroke(255);rect(width-90,10,30,30);
  stroke(0); fill(0); textSize(20);text("R",width-75,32);
  if ((mouseX>=width-90)&&(mouseX<=width-60)&&(mouseY>=10)&&(mouseY<=40)&&(mouseButton==LEFT)){if(oneloopretreived){retreive();}}
  else{oneloopretreived=true;}
  fill(255);stroke(255);rect(width-140,10,30,30);
  stroke(0); fill(0); textSize(20);text("S",width-125,32);
  if ((mouseX>=width-140)&&(mouseX<=width-110)&&(mouseY>=10)&&(mouseY<=40)&&(mouseButton==LEFT)){if(oneloopsave){savecode();}}
  else{oneloopsave=true;}
  fill(255);stroke(255);rect(width-190,10,30,30);
  if(consolecheck==0){fill(0,255,0);stroke(0,255,0);}else{fill(255,0,0);stroke(255,0,0);}triangle(width-180-1/2*10,25+sqrt(3)/2*10, width-180-1/2*10,25-sqrt(3)/2*10, width-180+10,25);
  if ((mouseX>=width-190)&&(mouseX<=width-160)&&(mouseY>=10)&&(mouseY<=40)&&(mouseButton==LEFT)){if(oneloopconsole){oneloopconsole=false;console();}}else{oneloopconsole=true;}
  if(consolecheck==1){commandout();}
}

void wheelexample(){c.display(20);c.shiftangle(30);c.movewheel(10);}

void coordinateupdate(){
  carvideo.locatex=video.locatex; carvideo.locatey=video.locatey;
  carvideo.ceta=video.ceta; carvideo.pi=video.pi;carvideo.size=video.size;}
  
void arrowcheck0(){
   float arrowx=0; //0~1400
   
   if(consolecheck==0){
   if(system.keyboardManager.isPressed('a')){A=255;cart.goRight();nothingPressed=0;}  
   if(system.keyboardManager.isPressed('d')){D=255;cart.goLeft();nothingPressed=0;}
   if(system.keyboardManager.isPressed('w')){W=255;cart.goFoward();nothingPressed=0;}
   if(system.keyboardManager.isPressed('s')){S=255;cart.goback();nothingPressed=0;}
   if(system.keyboardManager.isPressed(' ')){space=255;cart.booster();nothingPressed=0;if(oneloopw==0){timebooster=0;oneloopw=1;}}else{oneloopw=0;}
   if(system.keyboardManager.isPressed(SHIFT+1)){ct=255;cart.stp();nothingPressed=0;}
   if(system.keyboardManager.isPressed(SHIFT)){
     if(system.keyboardManager.isPressed('a')){DA=0;cart.godriftLeft();nothingPressed=0;}else{cart.velocity.moveceta(4*timedrift);}
     if(system.keyboardManager.isPressed('d')){DD=0;cart.godriftRight();nothingPressed=0;}else{cart.velocity.moveceta(-4*timedrift);}    
   }else{cart.k=0.2;timedrift=0;}
   if(system.keyboardManager.isPressed('r')){cart.position=new PVector(0,0,0);}
   if(nothingPressed==1){cart.nothing();}
   }
   
   textSize(30);
   stroke(0);fill(255-A+127*(1-DA),255-A,127+127*DA);rect(arrowx+110,810,80,80);
   if(DA==1){fill(0);stroke(0);text("A",arrowx+150,860);}if(DA==0){fill(0);stroke(0);text("DA",arrowx+150,860);}
   stroke(0);fill(255-W,255-W,255);rect(arrowx+210,710,80,80);fill(0);stroke(0);text("W",arrowx+250,760);
   stroke(0);fill(255-S,255-S,255);rect(arrowx+210,810,80,80);fill(0);stroke(0);text("S",arrowx+250,860);
   stroke(0);fill(255-D+127*(1-DD),255-D,127+127*DD);rect(arrowx+310,810,80,80);
   if(DD==1){fill(0);stroke(0);text("D",arrowx+350,860);}if(DD==0){fill(0);stroke(0);text("DD",arrowx+350,860);}
   stroke(0);fill(255-space,255,255-space);ellipse(arrowx+50,850,70,70);fill(0);stroke(0);text("!",arrowx+50, 860);
   stroke(0);fill(255,255-ct,255-ct);ellipse(arrowx+50,750,70,70);fill(0);stroke(0);text("stop",arrowx+50, 760);
   
   fill(255,255,255);stroke(0);rect(500,770,800,50);
   fill(0);text((abs(cart.velocity.z)<0.001 ? 0:cart.velocity.z)+"km/h",900,870);
   fill(255,0,0);stroke(255,0,0);line(900+300*cart.velocity.z/300,770,900+300*cart.velocity.z/300,820);fill(0);stroke(0);
   noFill();stroke(0);rect(500,770,800,50);fill(0);stroke(0);
   
   cart.nothing();
   fill(0);stroke(0);
}

float A,W,S,D,ct,DA,DD,space,nothingPressed,oneloopw;

void arrowcheck1(){
   float arrowx=0; //0~1400
   
   textSize(30);stroke(0);fill(255-A+127*(1-DA),255-A,127+127*DA);rect(arrowx+110,810,80,80);
   if(DA==1){fill(0);stroke(0);text("A",arrowx+150,860);}if(DA==0){fill(0);stroke(0);text("DA",arrowx+150,860);}
   stroke(0);fill(255-W,255-W,255);rect(arrowx+210,710,80,80);fill(0);stroke(0);text("W",arrowx+250,760);
   stroke(0);fill(255-S,255-S,255);rect(arrowx+210,810,80,80);fill(0);stroke(0);text("S",arrowx+250,860);
   stroke(0);fill(255-D+127*(1-DD),255-D,127+127*DD);rect(arrowx+310,810,80,80);
   if(DD==1){fill(0);stroke(0);text("D",arrowx+350,860);}if(DD==0){fill(0);stroke(0);text("DD",arrowx+350,860);}
   stroke(0);fill(255-space,255,255-space);ellipse(arrowx+50,850,70,70);fill(0);stroke(0);text("!",arrowx+50, 860);
   stroke(0);fill(255,255-ct,255-ct);ellipse(arrowx+50,750,70,70);fill(0);stroke(0);text("stop",arrowx+50, 760);
   
   fill(255,255,255);stroke(0);rect(500,770,800,50);
   fill(0);text((abs(cart.velocity.z)<0.001 ? 0:cart.velocity.z)+"km/h",900,870);
   fill(255,0,0);stroke(255,0,0);line(900+300*cart.velocity.z/300,770,900+300*cart.velocity.z/300,820);fill(0);stroke(0);
   noFill();stroke(0);rect(500,770,800,50);fill(0);stroke(0);
   fill(0);stroke(0);
   
   cart.nothing();
   fill(0);stroke(0);
}
}