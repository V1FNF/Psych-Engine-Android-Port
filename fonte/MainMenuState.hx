pacote;

#if área de trabalho

importar Discord.DiscordClient;

#fim

importar flixel.FlxG;

importar flixel.FlxObject;

importar flixel.FlxSprite;

importar flixel.FlxCamera;

importar flixel.addons.transition.FlxTransitionableState;

importar flixel.effects.FlxFlicker;

importar flixel.graphics.frames.FlxAtlasFrames;

importar flixel.group.FlxGroup.FlxTypedGroup;

importar flixel.text.FlxText;

importar flixel.math.FlxMath;

importar flixel.tweens.FlxEase;

importar flixel.tweens.FlxTween;

importar flixel.util.FlxColor;

import lime.app.Application;

importação Conquistas;

importar editores.MasterEditorMenu;

usando StringTools;

classe MainMenuState estende MusicBeatState

{

	public static var psychEngineVersion:String = '0.4.2'; //Isso também é usado para Discord RPC	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	private var camGame:FlxCamera;

	private var camAchievement:FlxCamera;

	

	var optionShit:Array<String> = ['freeplay', 'credits', 'donate', 'options'];

	var magenta:FlxSprite;

	var camFollow:FlxObject;

	var camFollowPos:FlxObject;

	substituir a função create()

	{

		#if área de trabalho

		// Atualizando o Discord Rich Presence

		DiscordClient.changePresence("Nos Menus", null);

		#fim

		camGame = new FlxCamera();

		camAchievement = new FlxCamera();

		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);

		FlxG.cameras.add(camAchievement);

		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;

		transOut = FlxTransitionableState.defaultTransOut;

		persistenteUpdate = persistDraw = true;

		var yScroll:Float = Math.max(0,25 - (0,05 * (optionShit.length - 4)), 0,1);

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));

		bg.scrollFactor.set(0, yScroll);

		bg.setGraphicSize(Std.int(bg.width * 1.175));

		bg.updateHitbox();

		bg.screenCenter();

		bg.antialiasing = ClientPrefs.globalAntialiasing;

		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollowPos = new FlxObject(0, 0, 1, 1);

		add(camSeguir);

		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));

		magenta.scrollFactor.set(0, yScroll);

		magenta.setGraphicSize(Std.int(magenta.width * 1.175));

		magenta.updateHitbox();

		magenta.screenCenter();

		magenta.visible = false;

		magenta.antialiasing = ClientPrefs.globalAntialiasing;

		magenta.color = 0xFFfd719b;

		add(magenta);

		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();

		add(menuItens);

		for (i em 0...optionShit.length)

		{

			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;

			var menuItem:FlxSprite = new FlxSprite(0, (i * 140) + deslocamento);

			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);

			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);

			menuItem.animation.addByPrefix('selected', optionShit[i] + "branco", 24);

			menuItem.animation.play('idle');

			menuItem.ID = i;

			menuItem.screenCenter(X);

			menuItems.add(menuItem);

			var scr:Float = (optionShit.length - 4) * 0,135;

			if(optionShit.length < 6) scr = 0;

			menuItem.scrollFactor.set(0, scr);

			menuItem.antialiasing = ClientPrefs.globalAntialiasing;

			//menuItem.setGraphicSize(Std.int(menuItem.width * 0,58));

			menuItem.updateHitbox();

		}

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);

		versionShit.scrollFactor.set();

		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(versionShit);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);

		versionShit.scrollFactor.set();

		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		alterarItem();

		#if ACHIEVEMENTS_ALLOWED

		Achievements.loadAchievements();

		var leDate = Date.now();

		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {

			var reachID:Int = Achievements.getAchievementIndex('friday_night_play');

			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //É uma noite de sexta-feira. WEEEEEEEEEEEEEEEEEE

				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);

				darConquista();

				ClientPrefs.saveSettings();

			}

		}

		#fim

		#if mobileC

		addVirtualPad(UP_DOWN, A_B_C);

		#fim

		super.criar();

	}

	#if ACHIEVEMENTS_ALLOWED

	// Desbloqueia a conquista "Freaky on a Friday Night"

	function darConquista() {

		add(new AchievementObject('friday_night_play', camAchievement));

		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

		trace('Dando conquista "friday_night_play"');

	}

	#fim

	var selectedSomethin:Bool = false;

	substituir atualização da função (decorrido:Float)

	{

		if (FlxG.sound.music.volume < 0,8)

		{

			FlxG.sound.music.volume += 0,5 * FlxG.elapsed;

		}

		var lerpVal:Float = CoolUtil.boundTo(decorrido * 5.6, 0, 1);

		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selecionadoAlgo)

		{

			if (controls.UI_UP_P)

			{

				FlxG.sound.play(Paths.sound('scrollMenu'));

				alterarItem(-1);

			}

			if (controls.UI_DOWN_P)

			{

				FlxG.sound.play(Paths.sound('scrollMenu'));

				alterarItem(1);

			}

			if (controles.VOLTAR)

			{

				selecionadoAlgo = verdadeiro;

				FlxG.sound.play(Paths.sound('cancelMenu'));

				MusicBeatState.switchState(new TitleState());

			}

			if (controles.ACEITAR)

			{

				if (optionShit[curSelected] == 'doar')

				{

					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');

				}

				senão

				{

					selecionadoAlgo = verdadeiro;

					FlxG.sound.play(Paths.sound('confirmMenu'));

					if(ClientPrefs.flash) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)

					{

						if (curSelected != spr.ID)

						{

							FlxTween.tween(spr, {alfa: 0}, 0,4, {

								facilidade: FlxEase.quadOut,

								onComplete: function(twn:FlxTween)

								{

									spr.kill();

								}

							});

						}

						senão

						{

							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)

							{

								var daChoice:String = optionShit[curSelected];

								interruptor (daEscolha)

								{

									case 'story_mode':

										MusicBeatState.switchState(new StoryMenuState());

									caso 'jogo livre':

										MusicBeatState.switchState(new FreeplayState());

									caso 'prêmios':

										MusicBeatState.switchState(new AchievementsMenuState());

									caso 'créditos':

										MusicBeatState.switchState(new CreditsState());

									caso 'opções':

										MusicBeatState.switchState(new OptionsState());

								}

							});

						}

					});

				}

			}

			else if (FlxG.keys.justPressed.SEVEN #if mobileC || _virtualpad.buttonC.justPressed #end)

			{

				selecionadoAlgo = verdadeiro;

				MusicBeatState.switchState(new MasterEditorMenu());

			}

		}

		super.update(decorrido);

		menuItems.forEach(function(spr:FlxSprite)

		{

			spr.screenCenter(X);

		});

	}

	função changeItem(huh:Int = 0)

	{

		curSelecionado += hein;

		if (curSelected >= menuItems.length)

			curSelecionado = 0;

		if (curSelecionado < 0)

			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)

		{

			spr.animation.play('idle');

			spr.offset.y = 0;

			spr.updateHitbox();

			if (spr.ID == curSelected)

			{

				spr.animation.play('selecionado');

				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);

				spr.offset.x = 0,15 * (spr.frameWidth / 2 + 180);

				spr.offset.y = 0,15 * spr.frameHeight;

				FlxG.log.add(spr.frameWidth);

			}

		});

	}

}
