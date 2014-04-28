package worlds {
	import flash.filters.GlowFilter;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import utils.gui.Button;
	import utils.WorldBase;
	import utils.Assets;
	import utils.Audio;

	public class WorldTitle extends WorldBase{
		
		public function WorldTitle() {
			super();
			addGraphic(new Image(Assets.TITLE));
			var b:Button = new Button(0, 150, "Play", onPlay, null, 0xD9AF4B, 3, 16, 80, 25);
			b.x = (320 - b.width)/2;
			add(b);
			Audio.playMusic(Assets.TITLE_MUSIC);
			
		}
		
		public function onPlay(obj:Object):void {
			this.switchWorld(WorldGame);
		}
		
	}

}