package utils {
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.ParticleType;
	/**
	* ...
	* @author Dreauw
	*/
	
	public class SyParticle extends Entity {
		static public var instance : SyParticle;
		public function SyParticle() {
			super(0, 0, new Emitter(Assets.PARTICLES, 10, 10));
			layer = 10;
			registerParticle();
		}
		
		public function newType(name:String, frames:Array = null):ParticleType {
			return (graphic as Emitter).newType(name, frames);
		}

		private function registerParticle() : void {
			/*
			newType("foobar", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10);
			*/
				
			newType("blood", [0])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10)
				.setRotation(0, 500);
			
			newType("bone", [1])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10)
				.setRotation(0, 500);
				
			newType("smoke", [2])
				.setAlpha(1, 0)
				.setMotion(0, 5, 0.2, 360, 0);
				
			newType("rock1", [3])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10)
				.setRotation(0, 500);
			
			newType("rock2", [4])
				.setAlpha(1, 0)
				.setMotion(0, 20, 0.7, 360, 0, 0.4)
				.setGravity(5, 10)
				.setRotation(0, 500);
				
			newType("water1", [5])
				.setAlpha(1, 0)
				.setMotion(0, 5, 0.7, 360, 0, 0.4)
				.setRotation(0, 500);
			
			newType("water2", [6])
				.setAlpha(1, 0)
				.setMotion(0, 5, 0.7, 360, 0, 0.4)
				.setRotation(0, 500);
				
			newType("lava1", [7])
				.setAlpha(1, 0)
				.setMotion(0, 5, 0.7, 360, 0, 0.4)
				.setRotation(0, 500);
			
			newType("lava2", [8])
				.setAlpha(1, 0)
				.setMotion(0, 5, 0.7, 360, 0, 0.4)
				.setRotation(0, 500);
				
			
		}

		static public function emit(name:String, x:Number, y:Number, nbr:Number = 1) : void {
			/*
			if (!instance || instance.world != FP.world) {
				instance = new SyParticle();
				if (instance.world) instance.world.remove(instance);
				FP.world.add(instance);
			}*/
			for (var i : Number = 0; i < nbr ; i++) {(instance.graphic as Emitter).emit(name, x, y);}
		}

	}

}