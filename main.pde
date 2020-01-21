//  ******************* 2018 Project 3 basecde ***********************
Boolean 
  showFloor=true,
  showBalls=true, 
  showPillars=false,
  animating=false, 
  showEdges=true,
  showTriangles=true,
  showVoronoi=true,
  showArcs=true,
  showCorner=true,
  showOpposite=true,
  showVoronoiFaces=true,
  live=true,   // updates mesh at each frame

  step1=false,
  step2=false,
  step3=false,
  step4=false,
  step5=false,
  step6=false,
  step7=false,
  step8=false,
  step9=false,
  step10=false,
  
  PickedFocus=false, 
  center=true, 
 
  scribeText=false; // toggle for displaying of help text


float 
  da = TWO_PI/32, // facet count for fans, cones, caplets
  t=0, 
  s=0,
  rb=50, // radius of the balls 
  rt=rb/2, // radius of tubes
  columnHeight = rb*3.7,
  h_floor=0, h_ceiling=600,  h=h_floor;
  
int
  f=0, 
  maxf=2*30, 
  level=4, 
  method=5,
  PTris=0,
  QTris=0,
  numberOfBorderEdges=0,
  tetCount=0;
 
pt Robot;
float RobotRadius;
pt RobotTarget;

float distanceTraveled;

pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R, S, T; 
EdgeSet BP = new EdgeSet();  
MESH M = new MESH();

void setup() {
  myFace = loadImage("data/pic.jpg");  // load image from file pic.jpg in folder data *** replace that file with your pic of your own face
  textureMode(NORMAL);          
  size(900, 900, P3D); // P3D means that we will do 3D graphics
  //size(600, 600, P3D); // P3D means that we will do 3D graphics
  P.declare(); Q.declare(); // P is a polyloop in 3D: declared in pts
  //P.resetOnCircle(6,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
  P.loadPts("data/pts");  
  Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
  noSmooth();
  //frameRate(30);
  sphereDetail(12);
  R=P; S=Q;
  println(); println("_______ _______ _______ _______");
  Robot = CircumCenter(R.G[0],R.G[1],R.G[2]);
  RobotTarget = Robot;
  RobotRadius = circumRadius(R.G[0],R.G[1],R.G[2]);
  distanceTraveled = 0;
  }

void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  if(showFloor) showFloor(h); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  R.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
    
  if(showBalls) 
      {
      fill(red); R.drawBalls(rb);
      fill(black,100); R.showPicked(rb+5); 
      }
  if(showPillars) 
      {
      fill(green); R.drawColumns(rb,columnHeight);
      fill(black,100); R.showPicked(rb+5); 
      }
    
  if(step1)
    {
    pushMatrix(); 
    translate(0,0,4); fill(cyan); stroke(yellow);
    if(live) 
      {
      M.reset(); 
      M.loadVertices(R.G,R.nv); 
      M.triangulate(); // **01 implement it in Mesh
      }
    if(showTriangles) M.showTriangles();
    noStroke();
    popMatrix();
    }
    
  if(step2)     
    {
    fill(yellow);
    if(live) {M.computeO();} // **02 implement it in Mesh
    if(showEdges) 
      {
      fill(yellow); 
      M.showNonBorderEdges(); // **02 implement it in Mesh
      fill(red); 
      M.showBorderEdges();} // **02 implement it in Mesh
    }
    
  if(step3)
    {
    M.classifyVertices();  // **03 implement it in Mesh
    showBalls=false;
    fill(green); noStroke(); 
    M.showVertices(rb+4); 
    }
    
  if(step4)
    {
    live = true;
    for(int i=0; i<10; i++) M.smoothenInterior(); // **04 implement it in Mesh
    M.writeVerticesTo(R);  
    }
    
 // **05 implement corner operators in Mesh
  if(step5) 
    {
    live = false;
    fill(magenta); 
    if(showCorner) M.showCurrentCorner(20); 
    if (showOpposite)
    {
      pushMatrix();
      translate(0,0,6); noFill(); stroke(black);
      M.showOpposites();
      popMatrix();
      
    }
    }
    
  if(step6)
    {
    live = true;
    pushMatrix(); 
    translate(0,0,6); noFill(); 
    stroke(blue); 
    if(showVoronoi) M.showVoronoiEdges(); // **06 implement it in Mesh
    stroke(red); 
    if(showArcs) M.showArcs(); // **06 implement it in Mesh
    noStroke();
    M.drawVoronoiFaces();
    popMatrix();
    }

  if(step7)
    {
    //fill(blue); show(R.G[0],1.1*rb);
    //fill(orange); beam(P.G[0],P.G[1],rt);
    //fill(grey); beam(R.G[0],R.G[1],1.1*rt); beam(R.G[1],R.G[2],1.1*rt); beam(R.G[2],R.G[0],1.1*rt);
    //fill(red); show(CircumCenter(R.G[0],R.G[1],R.G[2]),15);
    translate(0,0,6); noFill();
    if (!live) 
    {
      stroke(blue); 
      if(showVoronoi) M.showVoronoiEdges(); // **06 implement it in Mesh
      
      stroke(red);
      
      float RobotHeight = 25*300*300/ (RobotRadius * RobotRadius);
      fill(magenta,200); pillar(Robot,RobotHeight, RobotRadius);
      fill(red); show(Of, 20);
      beam(Of, P(Of.x, Of.y, RobotHeight), 5);
      beam(P(Robot.x, Robot.y, RobotHeight), P(Of.x, Of.y, RobotHeight), 5);
      
      M.advanceRobot();
    }
    else
    {
      Robot = CircumCenter(R.G[0],R.G[1],R.G[2]);
      RobotTarget = Robot;
      RobotRadius = circumRadius(R.G[0],R.G[1],R.G[2]);
    }
    
    }
    
  if(step8)
    {
      translate(0,0,6); noFill();
      if (!live) 
      {

        if(showVoronoi) 
        {
          stroke(blue); 
          if(showVoronoi) M.showVoronoiEdges(); // **06 implement it in Mesh
          noStroke();
          M.drawVisitedFaces();

        }// **06 implement it in Mesh
        
        stroke(red);
        
        float RobotHeight = 25*300*300/ (RobotRadius * RobotRadius);
        fill(magenta,200); pillar(Robot,RobotHeight, RobotRadius);
        //fill(red); show(Of, 20);
        //beam(Of, P(Of.x, Of.y, RobotHeight), 5);
        //beam(P(Robot.x, Robot.y, RobotHeight), P(Of.x, Of.y, RobotHeight), 5);
        
        M.advanceRobot();
      }
      else
      {
        M.reset(); 
        M.loadVertices(R.G,R.nv); 
        M.triangulate(); // **01 implement it in Mesh
        M.computeO();
        
        
        Robot = CircumCenter(M.G[M.V[0]],M.G[M.V[1]],M.G[M.V[2]]);
        RobotTarget = Robot;
        RobotRadius = circumRadius(M.G[M.V[0]],M.G[M.V[1]],M.G[M.V[2]]);
        distanceTraveled = 0;
      }
    }
    
  if(step9)
    {
    }
    
  if(step10)
    {
    }

  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible

  int line=0;
  scribeHeader(" Project 3 for Rossignac's 2018 Graphics Course CS3451 by Chianne Connelly ",line++);
  scribeHeader(P.count()+" vertices, "+M.nt+" triangles ",line++);
  if(live) scribeHeader("LIVE",line++);
 
  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (animating || change)) {print("."); saveFrame("../MOVIE FRAMES (PLEASE DO NOT SUBMIT)/F"+nf(frameCounter++,4)+".tif"); change=false;} // save next frame to make a movie
  if(filming && (animating || change)) {print("."); change=false;} // save next frame to make a movie
  //change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  //change=true;
  }