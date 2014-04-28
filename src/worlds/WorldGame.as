package worlds {
	import entities.Bullet;
	import entities.BulletRocket;
	import entities.DashArrow;
	import entities.Map;
	import entities.Player;
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Tween;
	import net.flashpunk.tweens.misc.ColorTween;
	import utils.WorldBase;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import utils.Assets;
	import utils.Audio;
	import utils.SyParticle;
	
	public class WorldGame extends WorldBase {
		public var map:Map;
		public var surfaceView:BitmapData;
		public var beneathView:BitmapData;
		public var playerBeneath:Player;
		public var surfaceFocused:Boolean = true;
		private var levelText:Text;
		public var arrow:DashArrow;
		public var levelId:uint = 0;
		public var warnings:Array = new Array();
		private var levelIntroTimer:Number = 0;
		private const INTRO_TIME:Number = 2;
		public var showScore:Boolean = false;
		private var scoreTxt:Text;
		public var score:Number = 0;
		public var timer:Number = 0.1;
		private var finalScore:Number = 0;
		private var canSwitchLevel:Boolean = false;
		
		
		public function WorldGame() {
			super();
			map = new Map();
			Input.define("SwitchLevel", Key.SPACE, Key.ENTER);
			surfaceView = new BitmapData(FP.screen.width / 2, 64);
			beneathView = new BitmapData(FP.screen.width / 2, (FP.screen.height / 2 - surfaceView.rect.height));
			levelText = new Text("Level 1", 0, 0, { size:32, alpha:0.5 } );
			levelText.filters = [new GlowFilter(0xFFFFFF)];
			scoreTxt = new Text("LEVEL COMPLETE !", 0, 0, { size:16 } );
			scoreTxt.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1)];
			loadLevel(0);
			Audio.playMusic(Assets.MUSIC, true);
		}
		
		public function transLoad():void {
			loadLevel(levelId);
		}
		
		public function loadLevel(i:uint):void {
			if (timer == 0) return;
			canSwitchLevel = false;
			showScore = false;
			finalScore += score;
			timer = 0;
			score = 0;
			
			levelText.text = "Level " + (i+1);
			levelText.x = (320 - levelText.width) / 4;
			levelText.alpha = 0.5;
			
			removeAll();
			add(SyParticle.instance = new SyParticle());
			addGraphic(new Backdrop(Assets.CAVERN_BACKGROUND), 0, 50, 20);
			
			map.loadLevel(i, this);
			addGraphic(Image.createRect(map.levelWidth, 51, 0x8dcaeb)).setHitbox(map.levelWidth, 51);
			playerBeneath.focus = false;
			levelIntroTimer = map.levelHeight <= FP.screen.width / 2 ? 0.5 : INTRO_TIME;
			if (levelId == i) levelIntroTimer = 0.1;
			levelId = i;
			FP.camera.y = 0;
			add(map);
			arrow = new DashArrow(playerBeneath);
			add(arrow);
		}
		
		override public function render():void {
			if (FP.camera.y - surfaceView.height <= 1) { 
				// No split if close
				FP.camera.y = 0;
				renderHeight = FP.screen.height/2;
				super.render();
				if (levelText.alpha > 0) {
					levelText.render(FP.buffer, new Point(levelText.x , surfaceView.height + 20), new Point());
				}
			} else {
				var yBuff:Number = FP.camera.y;
				// Beneath
				renderHeight = beneathView.height;
				super.render();
				beneathView.copyPixels(FP.buffer, beneathView.rect, new Point);
				if (levelText.alpha > 0) {
					levelText.render(beneathView, new Point(levelText.x , 20), new Point());
				}
				
				var buff : Array = new Array();
				getType("bullet", buff);
				for each (var b:Bullet in buff) {
					if (b.y < FP.camera.y)
					b.warning.render(beneathView, new Point(b.x - FP.camera.x, 2), new Point());
				}
				
				
				buff = new Array();
				getType("playerRocket", buff);
				for each (var br:BulletRocket in buff) {
					if (br.y < FP.camera.y)
					br.warning.render(beneathView, new Point(br.x - FP.camera.x , 2), new Point());
				}
				
				// Surface
				FP.camera.y = 0;
				FP.screen.refresh();
				renderHeight = surfaceView.height;
				super.render();
				surfaceView.copyPixels(FP.buffer, surfaceView.rect, new Point);
				surfaceView.fillRect(new Rectangle(0, surfaceView.height - 1, surfaceView.width, 1), 0xFF000000);
				//surfaceText.render(surfaceView, new Point(0, surfaceView.height - 20), new Point());
				
				// Merge
				FP.buffer.copyPixels(surfaceView, surfaceView.rect, new Point);
				FP.buffer.copyPixels(beneathView, beneathView.rect, new Point(0, surfaceView.rect.height));
				FP.camera.y = yBuff;
			}
			
			if (showScore) {
				FP.buffer.applyFilter(FP.buffer, FP.buffer.rect, new Point(), new BlurFilter(8, 8));
				scoreTxt.render(FP.buffer, new Point((320 - scoreTxt.width)/2, 50), new Point());
			}
		}
		
		
		override public function update():void {
			super.update();
			if (!showScore) timer += FP.elapsed;
			if (levelIntroTimer > 0) {
				if (map.levelHeight > FP.screen.width / 2)
					FP.camera.y = (INTRO_TIME - levelIntroTimer)/INTRO_TIME * (map.levelHeight - beneathView.height);
				levelIntroTimer -= FP.elapsed;
				if (levelIntroTimer <= 0) {
					playerBeneath.focus = true;
					var tw:ColorTween = new ColorTween();
					tw.tween(0.5, 0xFFFFFF, 0xFFFFFF, levelText.alpha - 0.1, 0);
					tw.image = levelText;
					tw.start();
					addTween(tw);
				}
			}
			
			if (Input.released(Key.R) || ((Input.mousePressed || Input.released(Key.SPACE)) && !canSwitchLevel && showScore)) {
				executeTransition(transLoad);
			} else if (canSwitchLevel && (Input.released("SwitchLevel") || Input.mousePressed)) {
				levelId++;
				executeTransition(transLoad);
			}
		}
		
		public function getMouseX() : Number {
			return FP.camera.x + Input.mouseX;
		}
		
		public function getMouseY(real:Boolean = false) : Number {
			if (real && Input.mouseY <= surfaceView.height) return Input.mouseY
			return FP.camera.y + Input.mouseY - (FP.camera.y - surfaceView.height <= 1 ? 0 : surfaceView.height);
		}
		
		
		public function levelComplete():void {
			Input.clear();
			var precision:uint = 0;
			if (timer >= 1) precision = 1;
			if (timer >= 10) precision = 2;
			if (timer >= 100) precision = 3;
			var str:String = Math.floor(timer / 60).toString() + ":" + Math.floor(timer % 60) + ":" + Math.floor((timer - Math.floor(timer)) * 100);
			if (levelId + 1 == map.maxLevel) {
				scoreTxt.text = "\t\tGAME COMPLETE !\n\n\t\tCongratulations !\n\t\tFinal Score : " + (finalScore+score) + "\n\nPress SPACE/CLICK to retry";
			} else {
				scoreTxt.text = "\t\tLEVEL COMPLETE !\n\n\t\tTime : " + str + "\n\t\tScore : " + score + "\n\n\t\tPress R to retry\nPress SPACE/CLICK to continue";
				canSwitchLevel = true;
			}
			showScore = true;
			
		}
		
		public function levelFailed():void {
			var precision:uint = 0;
			if (timer >= 1) precision = 1;
			if (timer >= 10) precision = 2;
			if (timer >= 100) precision = 3;
			var str:String = Math.floor(timer / 60).toString() + ":" + Math.floor(timer % 60) + ":" + Math.floor((timer - Math.floor(timer)) * 100);
			
			scoreTxt.text = "\t\tLEVEL FAILED !\n\n\t\tTime : " + str + "\n\t\tScore : " + score + "\n\nPress SPACE/CLICK to retry";
			showScore = true;
			canSwitchLevel = false;
		}
	}

}