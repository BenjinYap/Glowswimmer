package {
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import Screener.*;
	
	public final class Main extends Sprite {
		public static var highScores:HighScores = new HighScores ();
		
		public function Initialize () {
			var screenMgr:ScreenManager = new ScreenManager ();
			addChild (screenMgr);
			screenMgr.NewBigScreen (ScreenType.Splash);
			//screenMgr.NewBigScreen (ScreenType.Menu);
		}
	}
}
