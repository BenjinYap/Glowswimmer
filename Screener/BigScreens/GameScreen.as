package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.ui.*;
	import flash.filters.*;
	import flash.utils.*;
	import Screener.*;
	import Game.*;
	
	public final class GameScreen extends BaseScreen {
		private var maxSpikeHeightDifference:Number = GameData.maxSpikeHeightDifference;
		private var minPathHeight:Number = GameData.minPathHeight;
		private var maxPathHeight:Number = GameData.maxPathHeight;
		private var framesToHard:int = GameData.framesToHard;
		
		private var worldCont:Sprite = new Sprite ();
		private var objectCont:Sprite = new Sprite ();//Includes clones, bubbles, and treasures
		private var topSpikes:Array = [];
		private var botSpikes:Array = [];
		private var spikes:Shape = new Shape ();
		private var maskCont:Sprite = new Sprite ();
		
		private var playerMask:MovieClip = new mcMask ();
		private var framesToMinLight:int = GameData.framesToMinLight;
		
		private var clonesEnabled:Boolean = false;
		private var cloneCountdown:int = 0;
		
		private var gemCountdown:int = GameData.gemCountdown;
		private var coinCountdown:int = GameData.coinCountdown;
		private var treasureEnabled:Boolean = false;
		private var pickedTreasure:Boolean = false;
		
		private var soundEnabled:Boolean = false;
		private var soundCountdown:int = 0;
		
		private var physics:Physics = new Physics ();
		
		private var gameOver:Boolean = false;
		private var mult:Number = 1;
		private var thoughtFrame:int = 0;
		private var frame:int = 0;
		private var blurOutFrame:int = 0;
		private var blur:BlurFilter = new BlurFilter ();
		
		public override function Initialize (arg:Object = null) {
			GameData.Reset ();
			
			playerMask.x = player.x + 25;
			playerMask.y = player.y;
			playerMask.width = GameData.maxLightSize;
			playerMask.height = playerMask.width;
			maskCont.addChild (playerMask);
			
			var g:Graphics = maskCont.graphics;
			g.beginFill (0x000000, 0);
			g.drawRect (0, 0, stage.stageWidth, stage.stageHeight);
			g.endFill ();
			maskCont.cacheAsBitmap = true;
			addChild (maskCont);
			
			for (var i:int = 0; i < GameData.numSpikes; i++) {
				topSpikes.push (new Point (i * GameData.spikeWidth, stage.stageHeight / 2 - maxPathHeight / 2));
				botSpikes.push (new Point (i * GameData.spikeWidth, stage.stageHeight / 2 + maxPathHeight / 2));
			}
			
			worldCont.addChild (spikes);
			worldCont.addChild (objectCont);
			
			for (var i:int = 0; i < player.numChildren; i++) {
				if (player.getChildAt (i) is mcHit) {
					DisplayObject (player.getChildAt (i)).visible = false;
				}
			}
			
			worldCont.addChild (player);
			player.Initialize ();
			
			worldCont.cacheAsBitmap = true;
			worldCont.mask = maskCont;
			addChild (worldCont);
			
			txtThought.autoSize = TextFieldAutoSize.LEFT;
			
			physics.SetPlayer (player);
			physics.SetThoughtTF (txtThought);
			physics.SetObjectCont (objectCont);
			physics.SetSpikes (spikes, topSpikes, botSpikes);
			physics.SetMaskCont (maskCont);
			physics.addEventListener (GameEvent.PlayerHitSpikes, onPlayerHitSpikes, false, 0, true);
			physics.addEventListener (GameEvent.ObjectOffScreen, onObjectOffScreen, false, 0, true);
			physics.addEventListener (GameEvent.PickTreasure, onPickTreasure, false, 0, true);
			addChild (physics);
			
			Activate ();
		}
		
		public override function Activate (modalScreenMessage:String = null) {
			if (modalScreenMessage == "quit") {
				screenMgr.NewBigScreen (ScreenType.Menu);
			} else {
				player.Activate ();
				
				addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
				stage.addEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown, false, 0, true);
				stage.focus = stage;
			}
		}
		
		public override function Deactivate () {
			player.Deactivate ();
			removeEventListener (Event.ENTER_FRAME, onFrame);
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		public override function PrepareToDie () {
			Deactivate ();
			
			worldCont.mask = null;
			physics.removeEventListener (GameEvent.PlayerHitSpikes, onPlayerHitSpikes);
			physics.removeEventListener (GameEvent.ObjectOffScreen, onObjectOffScreen);
			physics.removeEventListener (GameEvent.PickTreasure, onPickTreasure);
			filters = [];
		}
		
		private function onFrame (e:Event) {
			DrawSpikes ();
			
			if (gameOver == false) {
				physics.Update ();
				
				CreateBubble ();

				if (topSpikes [0].x < -GameData.spikeWidth) {
					GenerateSpike ();
				}
				
				if (framesToMinLight > 0) {
					playerMask.width -= (GameData.maxLightSize - GameData.minLightSize) / GameData.framesToMinLight;
					playerMask.height = playerMask.width;
					framesToMinLight--;
				}
				
				if (framesToHard > 0) {
					maxSpikeHeightDifference += (GameData.hardMaxSpikeHeightDifference - GameData.maxSpikeHeightDifference) / GameData.framesToHard;
					minPathHeight -= (GameData.minPathHeight - GameData.hardMinPathHeight) / GameData.framesToHard;
					maxPathHeight -= (GameData.maxPathHeight - GameData.hardMaxPathHeight) / GameData.framesToHard;
					framesToHard--;
				}
				
				if (clonesEnabled == false && frame >= GameData.cloneDebut) {
					clonesEnabled = true;
					cloneCountdown = GameData.cloneCountdown + Math.floor (Math.random () * (GameData.cloneCountdown * GameData.countdownDeviation * 2)) - GameData.cloneCountdown * GameData.countdownDeviation;
				}
				
				if (clonesEnabled) {
					if (cloneCountdown == 0) {
						CreateClones ();
						cloneCountdown = GameData.cloneCountdown + Math.floor (Math.random () * (GameData.cloneCountdown * GameData.countdownDeviation * 2)) - GameData.cloneCountdown * GameData.countdownDeviation;
					} else {
						cloneCountdown--;
					}
				}
				
				if (treasureEnabled == false && frame >= GameData.treasureDebut) {
					treasureEnabled = true;
					gemCountdown = GameData.gemCountdown + Math.floor (Math.random () * (GameData.gemCountdown * GameData.countdownDeviation * 2)) - GameData.gemCountdown * GameData.countdownDeviation;
					coinCountdown = GameData.coinCountdown + Math.floor (Math.random () * (GameData.coinCountdown * GameData.countdownDeviation * 2)) - GameData.coinCountdown * GameData.countdownDeviation;
				}
				
				if (treasureEnabled) {
					if (gemCountdown == 0) {
						CreateTreasure (true);
						gemCountdown = GameData.gemCountdown + Math.floor (Math.random () * (GameData.gemCountdown * GameData.countdownDeviation * 2)) - GameData.gemCountdown * GameData.countdownDeviation;
					} else {
						gemCountdown--;
					}
					
					if (coinCountdown == 0) {
						CreateTreasure (false);
						coinCountdown = GameData.coinCountdown + Math.floor (Math.random () * (GameData.coinCountdown * GameData.countdownDeviation * 2)) - GameData.coinCountdown * GameData.countdownDeviation;
					} else {
						coinCountdown--;
					}
				}
				
				if (soundEnabled == false && frame >= GameData.soundDebut) {
					soundEnabled = true;
					soundCountdown = GameData.soundCountdown + Math.floor (Math.random () * (GameData.soundCountdown * GameData.countdownDeviation * 2)) - GameData.soundCountdown * GameData.countdownDeviation;
				}
				
				if (soundEnabled) {
					if (soundCountdown == 0) {
						SoundManager.PlayStrangeSound ();
						soundCountdown = GameData.soundCountdown + Math.floor (Math.random () * (GameData.soundCountdown * GameData.countdownDeviation * 2)) - GameData.soundCountdown * GameData.countdownDeviation;
					} else {
						soundCountdown--;
					}
				}
				
				GameData.score += mult * GameData.worldSpeed;
				txtScore.text = "x" + mult.toFixed (1) + "  " + GameData.score.toString ();
				
				if (thoughtFrame > 0) {
					if (thoughtFrame < 30) {
						txtThought.alpha = thoughtFrame / 30;
					}
					
					thoughtFrame--;
				} else {
					txtThought.alpha = 0;
				}
				
				for (var key:String in GameData.thoughts) {
					if (GameData.thoughts [key].auto && frame == GameData.thoughts [key].debut) {
						ShowThought (GameData.thoughts [key].thought);
						SoundManager.PlayThought (GameData.thoughts [key].voice);
					}
				}
			} else {
				if (blurOutFrame > 0) {
					blur.blurX = ((GameData.blurOutFrames - blurOutFrame) / GameData.blurOutFrames) * GameData.maxBlur;
					blur.blurY = blur.blurX;
					filters = [blur];
					blurOutFrame--;
				} else {
					screenMgr.NewBigScreen (ScreenType.GameOver);
				}
			}
			
			frame++;
		}
		
		private function onPlayerHitSpikes (e:GameEvent) {
			GameOver ();
		}
		
		private function onCloneOffScreen (e:GameEvent) {
			Clone (e.data).PrepareToDie ();
			objectCont.removeChild (Clone (e.data));
		}
		
		private function onTreasureOffScreen (e:GameEvent) {
			RemoveTreasure (Treasure (e.data), Treasure (e.data).theMask);
		}
		
		private function onObjectOffScreen (e:GameEvent) {
			if (e.data is Clone) {
				Clone (e.data).PrepareToDie ();
			} else if (e.data is Treasure) {
				maskCont.removeChild (Treasure (e.data).theMask);
			}
			
			objectCont.removeChild (DisplayObject (e.data));
		}
		
		private function onPickTreasure (e:GameEvent) {
			if (pickedTreasure == false) {
				pickedTreasure = true;
				ShowThought (GameData.thoughts.treasure.thought);
				SoundManager.PlayThought (GameData.thoughts.treasure.voice);
			}
			
			//SoundManager.PlayTreasureGet ();
			
			var treasure:Treasure = Treasure (e.data);
			
			if (treasure.isGem) {
				mult += GameData.gemMult;
				GameData.numGemsGot++;
			} else {
				GameData.score += mult * GameData.coinScore;
				GameData.numCoinsGot++;
			}
			
			maskCont.removeChild (treasure.theMask);
			objectCont.removeChild (treasure);
		}
		
		private function onStageKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ESCAPE) {
				Pause ();
			}
		}
		
		private function DrawSpikes () {
			var g:Graphics = spikes.graphics;
			g.clear ();
			
			var smallestY:int = 1000;
			var leftSpikeIndex:int = -1;
			var rightSpikeIndex:int = -1;
			var foundRightSpike:Boolean = false;
			
			for (var i:int = 1; i < GameData.numSpikes; i++) {				
				if (topSpikes [i].x + 100 > player.x && leftSpikeIndex == -1) {
					leftSpikeIndex = i;
				}
				
				if (topSpikes [i].x - 100 > player.x && rightSpikeIndex == -1) {
					rightSpikeIndex = i - 1;
					foundRightSpike = true;
				}
				
				if (topSpikes [i].y < smallestY) {
					smallestY = topSpikes [i].y;
				}
				
				if (foundRightSpike) {
					break;
				}
			}
			
			g.moveTo (topSpikes [leftSpikeIndex].x, topSpikes [leftSpikeIndex].y);
			g.lineStyle (2, GameData.wallColor);
			g.beginFill (GameData.wallColor, 0);
			
			for (var i:int = leftSpikeIndex + 1; i < rightSpikeIndex + 1; i++) {
				g.curveTo (topSpikes [i].x, topSpikes [i - 1].y, topSpikes [i].x, topSpikes [i].y);
			}
			
			g.lineStyle (0, GameData.wallColor, 0);
			g.lineTo (topSpikes [rightSpikeIndex].x, smallestY);
			g.lineTo (topSpikes [leftSpikeIndex].x, smallestY);
			g.lineTo (topSpikes [leftSpikeIndex].x, topSpikes [leftSpikeIndex].y);
			g.endFill ();
			
			g.lineStyle (2, GameData.wallColor);
			g.moveTo (topSpikes [0].x, topSpikes [0].y);
			
			for (var i:int = 1; i < leftSpikeIndex + 1; i++) {
				g.curveTo (topSpikes [i].x, topSpikes [i - 1].y, topSpikes [i].x, topSpikes [i].y);
			}
			
			g.moveTo (topSpikes [rightSpikeIndex].x, topSpikes [rightSpikeIndex].y);
			
			for (var i:int = rightSpikeIndex + 1; i < GameData.numSpikes; i++) {
				g.curveTo (topSpikes [i].x, topSpikes [i - 1].y, topSpikes [i].x, topSpikes [i].y);
			}
			
			var biggestY:int = 0;
			leftSpikeIndex = -1;
			rightSpikeIndex = -1;
			foundRightSpike = false;
			
			for (var i:int = 1; i < GameData.numSpikes; i++) {				
				if (botSpikes [i].x + 100 > player.x && leftSpikeIndex == -1) {
					leftSpikeIndex = i;
				}
				
				if (botSpikes [i].x - 100 > player.x && rightSpikeIndex == -1) {
					rightSpikeIndex = i - 1;
					foundRightSpike = true;
				}
				
				if (botSpikes [i].y > biggestY) {
					biggestY = botSpikes [i].y;
				}
				
				if (foundRightSpike) {
					break;
				}
			}
			
			g.moveTo (botSpikes [leftSpikeIndex].x, botSpikes [leftSpikeIndex].y);
			g.lineStyle (2, GameData.wallColor);
			g.beginFill (GameData.wallColor, 0);
			
			for (var i:int = leftSpikeIndex + 1; i < rightSpikeIndex + 1; i++) {
				g.curveTo (botSpikes [i].x, botSpikes [i - 1].y, botSpikes [i].x, botSpikes [i].y);
			}
			
			g.lineStyle (0, GameData.wallColor, 0);
			g.lineTo (botSpikes [rightSpikeIndex].x, biggestY);
			g.lineTo (botSpikes [leftSpikeIndex].x, biggestY);
			g.lineTo (botSpikes [leftSpikeIndex].x, botSpikes [leftSpikeIndex].y);
			g.endFill ();
			
			g.lineStyle (2, GameData.wallColor);
			g.moveTo (botSpikes [0].x, botSpikes [0].y);
			
			for (var i:int = 1; i < leftSpikeIndex + 1; i++) {
				g.curveTo (botSpikes [i].x, botSpikes [i - 1].y, botSpikes [i].x, botSpikes [i].y);
			}
			
			g.moveTo (botSpikes [rightSpikeIndex].x, botSpikes [rightSpikeIndex].y);
			
			for (var i:int = rightSpikeIndex + 1; i < GameData.numSpikes; i++) {
				g.curveTo (botSpikes [i].x, botSpikes [i - 1].y, botSpikes [i].x, botSpikes [i].y);
			}
		}
		
		private function GenerateSpike () {
			for (var i:int = 0; i < GameData.numSpikes - 1; i++) {
				topSpikes [i] = topSpikes [i + 1].clone ();
				botSpikes [i] = botSpikes [i + 1].clone ();
			}
			
			
			var lastSpike:Point = topSpikes [GameData.numSpikes - 1].clone ();
			var newTopSpike:Point = new Point (lastSpike.x + GameData.spikeWidth, 0);
			var topH:int = lastSpike.y;
			
			if (lastSpike.y - maxSpikeHeightDifference < GameData.minSpikeHeight) {
				topH += Math.floor (Math.random () * (lastSpike.y - GameData.minSpikeHeight + maxSpikeHeightDifference)) - (lastSpike.y - GameData.minSpikeHeight);
			} else if (lastSpike.y + maxSpikeHeightDifference > stage.stageHeight - GameData.minSpikeHeight) {
				topH += Math.floor (Math.random () * (stage.stageHeight - GameData.minSpikeHeight - lastSpike.y + maxSpikeHeightDifference)) - maxSpikeHeightDifference;
			} else {
				topH += Math.floor (Math.random () * (maxSpikeHeightDifference * 2)) - maxSpikeHeightDifference;
			}
			
			lastSpike = botSpikes [GameData.numSpikes - 1].clone ();
			var newBotSpike:Point = new Point (lastSpike.x + GameData.spikeWidth, 0);
			var botH:int = lastSpike.y;
			
			if (lastSpike.y - maxSpikeHeightDifference < GameData.minSpikeHeight) {
				botH += Math.floor (Math.random () * (lastSpike.y - GameData.minSpikeHeight + maxSpikeHeightDifference)) - (lastSpike.y - GameData.minSpikeHeight);
			} else if (lastSpike.y + maxSpikeHeightDifference > stage.stageHeight - GameData.minSpikeHeight) {
				botH += Math.floor (Math.random () * (stage.stageHeight - GameData.minSpikeHeight - lastSpike.y + maxSpikeHeightDifference)) - maxSpikeHeightDifference;
			} else {
				botH += Math.floor (Math.random () * (maxSpikeHeightDifference * 2)) - maxSpikeHeightDifference;
			}
			
			if (botH - topH < minPathHeight) {
				var diff:int = minPathHeight - (botH - topH);
				topH -= Math.ceil (diff / 2);
				botH += Math.ceil (diff / 2);
			} else if (botH - topH > maxPathHeight) {
				var diff:int = botH - topH - maxPathHeight;
				topH += Math.ceil (diff / 2);
				botH -= Math.ceil (diff / 2);
			}
			
			newTopSpike.y = topH;
			newBotSpike.y = botH;
			topSpikes [GameData.numSpikes - 1] = newTopSpike;
			botSpikes [GameData.numSpikes - 1] = newBotSpike;
		}
		
		private function GameOver () {
			Deactivate ();
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
			
			gameOver = true;
			blurOutFrame = GameData.blurOutFrames;
		}
		
		private function CreateClones () {
			for (var i:int = 0; i < Math.floor (Math.random () * GameData.maxClones) + 1; i++) {
				var clone:Clone = new Clone ();
				objectCont.addChild (clone);
				clone.Initialize (player.y);
			}
		}
		
		private function CreateTreasure (isGem:Boolean) {
			var theMask:MovieClip = new mcMask ();
			
			var treasure:Treasure = new Treasure ();
			objectCont.addChild (treasure);
			treasure.Initialize (isGem, new Point (topSpikes [GameData.numSpikes - 1].x, topSpikes [GameData.numSpikes - 1].y + treasure.height * 2 + Math.random () * (botSpikes [GameData.numSpikes - 1].y - topSpikes [GameData.numSpikes - 1].y - treasure.height * 2)), theMask);
			
			theMask.width = GameData.treasureLightSize;
			theMask.height = theMask.width;
			theMask.x = treasure.x;
			theMask.y = treasure.y;
			maskCont.addChild (theMask);
			
			if (isGem) {
				GameData.numGems++;
			} else {
				GameData.numCoins++;
			}
		}
		
		private function RemoveTreasure (treasure:Treasure, Mask:MovieClip) {
			objectCont.removeChild (treasure);
			maskCont.removeChild (Mask);
		}
		
		private function ShowThought (thought:String) {
			txtThought.text = thought;
			txtThought.alpha = 1;
			thoughtFrame = GameData.thoughtFrames;
		}
		
		private function CreateBubble () {
			var bubble:MovieClip = new mcBubble ();
			bubble.x = player.x - Math.random () * (GameData.avatarSize.x / 2);
			bubble.y = player.y + Math.random () * (GameData.avatarSize.y) - GameData.avatarSize.y / 2;
			objectCont.addChild (bubble);
		}
		
		private function Pause () {
			screenMgr.AddModalScreen (ScreenType.Pause);
		}
	}
}