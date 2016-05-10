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
  size(1280, 720, P3D);

  applet = this;

  // Create world.
  world = new BWorld();
  world.init(20);
//  world.init(new Rect(0, 0, width, height));

  // the NEW way to add gravity to the simulation, using behaviors
  //world.addBehavior(new GravityBehavior(new Vec2D(0, 0.015f)));
  world.setConstantForce(new Vec2D(0, 0.1f));

  mousePos = new Vec2D(mouseX, mouseY);
}

void addTrash() {
  StateParticle p = new StateParticle(new Vec2D(mouseX, mouseY), new StateTrash());
  p.setWeight(random(0.5, 3));
  world.addBParticle(p);
  world.addBehavior(new AttractionBehavior(p, p.getWeight()*20, -0.1f, 0.01f));
}

void draw() {
  mousePos.set(mouseX, mouseY);
  background(0, 0, 128);
  noStroke();
  if (mousePressed) {
    println("Add particle");
    addTrash();
  }
  world.update();
  world.draw();
  // fill(255);
  // for (VerletParticle2D p : world.particles)
  //   ellipse(p.x(), p.y(), 20, 20);
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
