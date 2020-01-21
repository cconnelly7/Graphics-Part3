// TRIANGLE MESH
class MESH {
    // VERTICES
    int nv=0, maxnv = 1000;  
    pt[] G = new pt [maxnv];
    boolean[] seen = new boolean[maxnv];
    // TRIANGLES 
    int nt = 0, maxnt = maxnv*2;    //Number of triangles i think                       
    boolean[] isInterior = new boolean[maxnv];
    pt[] centers = new pt[maxnv];
    boolean[] visited = new boolean[maxnv];
    // CORNERS 
    int c=0;    // current corner                                                              
    int nc = 0; 
    int[] V = new int [3*maxnt];   
    int[] O = new int [3*maxnt];
    
    // current corner that can be edited with keys
  MESH() {for (int i=0; i<maxnv; i++) G[i]=new pt();};
  void reset() {nv=0; nt=0; nc=0;}                                                  // removes all vertices and triangles
  void loadVertices(pt[] P, int n) {nv=0; for (int i=0; i<n; i++) addVertex(P[i]);}
  void writeVerticesTo(pts P) {for (int i=0; i<nv; i++) P.G[i].setTo(G[i]);}
  void addVertex(pt P) { G[nv++].setTo(P); }                                             // adds a vertex to vertex table G
  void addTriangle(int i, int j, int k) {V[nc++]=i; V[nc++]=j; V[nc++]=k; nt=nc/3; }     // adds triangle (i,j,k) to V table
  boolean isInCircle(CIRCLE C, pt p){
    return d(C.Center, p) < C.radius;
  }

  // CORNER OPERATORS
  int t (int c) {int r=int(c/3); return(r);}                   // triangle of corner c
  int n (int c) {int r=3*int(c/3)+(c+1)%3; return(r);}         // next corner
  int p (int c) {int r=3*int(c/3)+(c+2)%3; return(r);}         // previous corner
  pt g (int c) {return G[V[c]];}                             // shortcut to get the point where the vertex v(c) of corner c is located

  boolean nb(int c) {return(O[c]!=c);};  // not a border corner
  boolean bord(int c) {return(O[c]==c);};  // not a border corner

  pt cg(int c) {return P(0.6,g(c),0.2,g(p(c)),0.2,g(n(c)));}   // computes offset location of point at corner c

  // CORNER ACTIONS CURRENT CORNER c
  void next() {c=n(c);}
  void previous() {c=p(c);}
  void opposite() {c=o(c);}
  void left() {c=l(c);}
  void right() {c=r(c);}
  void swing() {c=s(c);} 
  void unswing() {c=u(c);} 
  void printCorner() {println("c = "+c);}
  
  

  // DISPLAY
  void showCurrentCorner(float r) { if(bord(c)) fill(red); else fill(dgreen); show(cg(c),r); };   // renders corner c as small ball
  void showEdge(int c) {beam( g(p(c)),g(n(c)),rt ); };  // draws edge of t(c) opposite to corner c
  void showVertices(float r) // shows all vertices green inside, red outside
    {
    for (int v=0; v<nv; v++) 
      {
      if(isInterior[v]) fill(green); else fill(red);
      show(G[v],r);
      }
    }                          
  void showInteriorVertices(float r) {for (int v=0; v<nv; v++) if(isInterior[v]) show(G[v],r); }                          // shows all vertices as dots
  void showTriangles() { for (int c=0; c<nc; c+=3) show(g(c), g(c+1), g(c+2)); }         // draws all triangles (edges, or filled)
  void showEdges() {for (int i=0; i<nc; i++) showEdge(i); };         // draws all edges of mesh twice

  void triangulate()      // performs Delaunay triangulation using a quartic algorithm
 {
   println("Triangulating!");
   c=0;                   // to reset current corner
   //float x =0; float y= 0; float z = 0;
   float r = 1;
   pt X= P();
   for (int i=0; i<nv-2; i++) for (int j=i+1; j<nv-1; j++) for (int k=j+1; k<nv; k++) {
        X=CircumCenter(G[i],G[j],G[k]);  r=d(X,G[i]);         
        boolean found=false; 
        for (int m=0; m<nv; m++) if ((m!=i)&&(m!=j)&&(m!=k)&&(d(X,G[m])<=r)) found=true;  
        if (!found) {
          centers[nt] = X;
          visited[nt] = false;
          if (cw(G[i], G[j], G[k])) {
               addTriangle(i,j,k);
          } else {
               addTriangle(k,j,i);
          }
          
        }; // end triple loop
    }
        
        
   //for(int x =0; x< nv-2; x++){
   //  for(int y =x +1; y< nv-1; y++){
   //    for(int z =y +1; z< nv; z++) {           
   //        CIRCLE C = new CIRCLE(CircumCenter(G[x], G[y], G[z]), circumRadius(G[x], G[y], G[z]));
   //        boolean foundPtInCircle = false;
   //        for(int p=0; p<nv; p++) {
   //          if (isInCircle(C, G[p]) && G[p] != G[x] && G[p] != G[y] && G[p] != G[z]){
   //            foundPtInCircle = true;
   //          }
   //        }
   //        if (!foundPtInCircle){
   //          if (cw(G[x], G[y], G[z])) {
   //            addTriangle(x,y,z);
   //          } else {
   //            addTriangle(z,y,x);
   //         }            
   //        }
   //    }
   //  }
   //}
 }  

   
  void computeO() // **02 implement it 
    {                                          
      for (int a = 0; a < nc; a++) {
      O[a] = a;
    }
    for (int i = 0; i < nc; i++) {
      for (int j = 0; j < nc; j++) {
        if((V[n(i)] == V[p(j)]) && (V[p(i)] == V[n(j)])) {
          O[j] = i;
          O[i] = j;
        }
      }
    }
    } 
    
  void showBorderEdges()  // draws all border edges of mesh
    {
    // **02 implement;
      for (int i = 0; i < nc; i++) {
      if (bord(i) == true) {
        showEdge(i); // if it's a border, show it
      }
    }
    }         

  void showNonBorderEdges() // draws all non-border edges of mesh
    {
    // **02 implement
    for (int i = 0; i < nc; i++) {
      if (bord(i) == false) {
        showEdge(i); // if it's NOT a border, show it
      }
    }
    }        
    
  void classifyVertices() 
    { 
      // **03 implement it
      for (int i = 0; i < nv; i++)
      {
        isInterior[i] = true;
      }
      for (int i = 0; i < nc; i++)
      {
        if (bord(i)){
          isInterior[V[p(i)]] = false;
          isInterior[V[n(i)]] = false;
        }
      }
    }  
    
  void smoothenInterior() { // even interior vertiex locations
    pt[] Gn = new pt[nv];
    for (int c=0; c<nc; c++)
    {
      if(isInterior[V[c]]) {
        int start = n(c);  // need a corner ID not a vertex ID
        int curr = start;
        pt avg = new pt();
        int count = 0;
        do
        {
          avg.add(G[V[curr]]);
          count++;
          curr = u(n(curr));
        } while (curr != start);
        
        avg.div(count);
        Gn[V[c]] = avg;
      }
    }
    
    for (int v=0; v<nv; v++) if(isInterior[v]) G[v].translateTowards(.1,Gn[v]);
    }


   // **05 implement corner operators in Mesh
  int v (int c) {return V[c];}                                // vertex of c
  int o (int c) {return O[c];}                                // opposite corner
  int l (int c) {return O[n(c)];}                             // left
  int s (int c) {return n(l(c));}                             // left
  int u (int c) {return p(r(c));}                             // left
  int r (int c) {return O[p(c)];}                             // right

  
  void showOpposites()
  {
    for (int c = 0; c< nc; c++)
    {
      if (!bord(c))
      {
        drawParabolaInHat(G[V[c]], G[V[n(c)]], G[V[O[c]]], 10);
      }
    }
  }
  void showVoronoiEdges() // draws Voronoi edges on the boundary of Voroni cells of interior vertices
    { 
      for (int c = 0; c< nc; c++)
      {
        if (!bord(c))
        {
          pt thisCenter = centers[c/3];
          pt otherCenter = centers[O[c]/3];
          show( thisCenter, otherCenter );
        }
      }
    }               

  void showArcs() // draws arcs of quadratic B-spline of Voronoi boundary loops of interior vertices
    { 
      for (int c = 0; c< nc; c++)
      {
        if (!bord(c))
        {
          pt thisCenter = centers[c/3];
          pt otherCenter = centers[O[c]/3];  //B
          pt midPoint = P(thisCenter, otherCenter); //A
          int unSwingIndex = u(o(c));
          pt thirdCenter = centers[unSwingIndex/3];
          pt C = P(otherCenter, thirdCenter); //C
          drawParabolaInHat(midPoint, otherCenter, C, 10);
        }
      }
    }               // draws arcs in triangles
    
    void drawVoronoiFaces()
    {
      float dc = 1./(nv -1);
      for (int v = 0; v<nv; v++)
      {
        if (isInterior[v])
        {
          fill(dc*255*v, dc*255*(nv-v), 200);
          int c = cornerIndexFromVertexIndex(v);
          beginShape();
          int start = c;
          int curr = start;
          do
          {
            vertex(centers[curr/3]);
            curr = s(curr);
          } while (curr != start);
          endShape(CLOSE);
        }
      }
    }
    
    void advanceRobot()
    {
      float shortestDistance = Float.MAX_VALUE;
      for (int v =0; v <nv; v++)
      {
        if (d(Robot, G[v]) < shortestDistance)
        {
          shortestDistance = d(Robot, G[v]);
        }
      }
      RobotRadius = shortestDistance - rb;
       Robot.translateTowards(.03,RobotTarget);
       if(d(Robot, RobotTarget) < 50)
       {
         //find the center index
         int centerIndex = -1;
         for (int i = 0; i < nt; i++)
         {
           if (d(RobotTarget, centers[i]) < 50)
           {
             centerIndex = i;
             visited[centerIndex] = true; 
           }
         }
         
         if (centerIndex >= 0)
         {
           if (step7)
           {
             pt nc0 = centers[o(centerIndex*3)/3];
             pt nc1 = centers[o(centerIndex*3 + 1)/3];
             pt nc2 = centers[o(centerIndex*3 + 2)/3];
             
             float d0 = d(nc0, Of);
             float d1 = d(nc1, Of);
             float d2 = d(nc2, Of);
             float currentDistance = d(Robot, Of);
             
             if (d0 < d1 && d0 < d2 && d0 < currentDistance)
             {
               RobotTarget = nc0;
             }
             else if (d1 < d2 & d1 < currentDistance)
             {
               RobotTarget = nc1;
             }
             else if (d2 < currentDistance)
             {
               RobotTarget = nc2;
             }
           }
           if (step8)
           {
             println("Total distance traveled is " + distanceTraveled);
             float shortest = Float.MAX_VALUE;
             RobotTarget = Robot;
             for(int c = 0; c < nt; c++)
             {
               if (!visited[c] && d(centers[c], Robot) < shortest)
               {
                 RobotTarget = centers[c];
                 shortest = d(centers[c], Robot);
               }
             }
             distanceTraveled+=shortest; 
           }
           
         }
       }
    }
    
    void drawVisitedFaces()
    {
      //float dc = 1./(nv -1);
      //for (int v = 0; v<nv; v++)
      //{
      //  int c = cornerIndexFromVertexIndex(v);
      //  if (isInterior[v] && visited[c/3])
      //  {
      //    println("Drawing it cyan!");
      //    fill(green);
      //    beginShape();
      //    int start = c;
      //    int curr = start;
      //    do
      //    {
      //      vertex(centers[curr/3]);
      //      curr = s(curr);
      //    } while (curr != start);
      //    endShape(CLOSE);
      //  }
      //}
      for (int c = 0; c<nt; c++)
      {
        if (visited[c])
        {
          fill(green);
          beginShape();
          vertex(G[V[c*3]]);
          vertex(G[V[c*3 + 1]]);
          vertex(G[V[c*3 + 2]]);
          endShape(CLOSE);
        }
      }
      
    }
    
    int cornerIndexFromVertexIndex(int v)
    {
      for (int c = 0; c<nc; c++)
      {
        if (V[c] == v)
        {
          return c;
        }
      }
      return -1; //should never happen
    }
    
    void clearVisited()
    {
      for (int c = 0; c<nt; c++)
      {
        visited[c] = false;
      }
    }
    

 
  pt triCenter(int c) {return P(g(c),g(n(c)),g(p(c))); }  // returns center of mass of triangle of corner c
  pt triCircumcenter(int c) {return CircumCenter(g(c),g(n(c)),g(p(c))); }  // returns circumcenter of triangle of corner c


  } // end of MESH
