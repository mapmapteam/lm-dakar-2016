import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

int NUM_PARTICLES = 750;

// Base variables.
BWorld world;

// Mouse-related.
AttractionBehavior mouseAttractor;
Vec2D mousePos;

PApplet applet;

void setup() {
  size(800, 600, P3D);

  applet = this;

  // Create world.
  world = new BWorld();
  world.init(new Rect(0, 0, width, height));

  // the NEW way to add gravity to the simulation, using behaviors
  //world.addBehavior(new GravityBehavior(new Vec2D(0, 0.015f)));

  mousePos = new Vec2D(mouseX, mouseY);

  for (int i=0; i<100; i++) {
  StateParticle p = new StateParticle(new Vec2D(random(0,width), random(0,height)), new StateButterfly());
    p.setWeight(2);
    addParticle();
//    world.addBParticle(p);
  }

//  frameRate(10);
}

void addParticle() {
  StateParticle p = new StateParticle(new Vec2D(random(0,width), random(0,height)), new StateTrash());
  p.setWeight(random(0.5, 3));
  world.addBParticle(p);
  // add a negative attraction force field around the new particle
  //world.addBehavior(new AttractionBehavior(p, 20, -1.2f, 0.01f));
}

void draw() {
  mousePos.set(width/2, height/2);
  background(0, 0, 128);
  noStroke();
  if (mousePressed) {
    println("Add particle");
    addParticle();
  }
  world.update();
  world.draw();
}

void mousePressed() {
  // create a new positive attraction force field around the mouse position (radius=250px)
  mouseAttractor = new AttractionBehavior(mousePos, 250, 0.1f);
  //world.addBehavior(mouseAttractor);
}

void mouseReleased() {
  // remove the mouse attraction when button has been released
  world.removeBehavior(mouseAttractor);
}
