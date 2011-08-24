package 
{
	import adobe.utils.CustomActions;
	import flash.display.*;
	import flash.events.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author Johannes L. Borresen
	 */
	public class Preloader extends MovieClip 
	{
		public var Progress:TextField = new TextField();
		
		public function Preloader() 
		{
			if (stage) {
				stop();
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			Progress.text = "Loading... ";
			addChild(Progress);
			Progress.x = Progress.y = 50;
			Progress.width = stage.stageWidth - 50;
			Progress.defaultTextFormat.align = TextFormatAlign.CENTER;
			trace("Loading");
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			// TODO update loader
			Progress.text = "Loading... " + e.bytesLoaded.toString() + "/" + e.bytesTotal.toString();
			trace(e.bytesLoaded.toString());
		}
		
		private function checkFrame(e:Event):void 
		{
			if (currentFrame == totalFrames) 
			{
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void 
		{
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO hide loader
			// removeChild(Progress);
			
			Progress.text = "Done!\n\nClick anywhere to continue.";
			stage.addEventListener(MouseEvent.CLICK, startup);
			
			// startup();
		}
		
		private function startup(e:Event):void 
		{
			this.removeEventListener(MouseEvent.CLICK, startup);
			removeChild(Progress);
			// var mainClass:Class = getDefinitionByName("Main") as Class;
			var mainClass:Class = Main;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}