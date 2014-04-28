package  
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	import net.flashpunk.Engine;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Dreauw
	 */
	public class Preloader extends MovieClip {
		private var label : TextField = new TextField();
		private var label2 : TextField = new TextField();
		private var progressBar : Shape = new Shape();
		private var paused : Boolean = false;
		public function Preloader() {
			if (stage) {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);

			progressBar.x = 100;
			progressBar.y = (stage.stageHeight - 50) / 2;
			addChild(progressBar);
			label.x = (stage.stageWidth - 72)/2;
			label.y = progressBar.y+10;
			var format:TextFormat = new TextFormat();

			label.autoSize = TextFieldAutoSize.LEFT;  
			label.text = "0%";
			label.selectable = false;
			format.font = "default";
			format.color = 0xFFFFFF;
			format.size = 32;
			label.defaultTextFormat = format;
			label.embedFonts = true;
			label.filters = [new GlowFilter(0)];
			
			
			label2.x = (stage.stageWidth - 270)/2;
			label2.y = stage.stageHeight - 50;
			format = new TextFormat();
			label2.autoSize = TextFieldAutoSize.LEFT;  
			
			label2.selectable = false;
			format.font = "default";
			format.color = 0xFFFFFF;
			format.size = 16;
			label2.defaultTextFormat = format;
			label2.embedFonts = true;
			label2.filters = [new GlowFilter(0)];
			
			
			progressBar.filters = [new GlowFilter(0xFFFFFF, 1, 4, 4)];
			addChild(label);
			addChild(label2);
			
			label2.text = "A game made by Dreauw in 48h";
		}

		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}

		private function progress(e:ProgressEvent):void {
			var percent:Number = e.bytesLoaded / e.bytesTotal;
			label.text = (percent*100).toFixed().toString() + "%";
			progressBar.graphics.clear();
			progressBar.graphics.lineStyle(2, 0xFFFFFF, 1.0, true);
			progressBar.graphics.drawRoundRect(0, 0, stage.stageWidth - 200, 50, 9);
			progressBar.graphics.beginFill(0xFFFFFF);
			progressBar.graphics.drawRoundRect(8, 8, percent*(stage.stageWidth-216), 34, 9);
			progressBar.graphics.endFill();
		}

		private function checkFrame(e:Event):void {
			if (currentFrame == totalFrames) {
				stop();
				loadingFinished();
			}
		}

		private function loadingFinished():void {
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			removeChild(progressBar);
			removeChild(label);
			progressBar = null;
			label = null;
			label2 = null;
			startup();
		}

		private function startup():void {
			var mainClass:Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as Engine);
		}

	}
}