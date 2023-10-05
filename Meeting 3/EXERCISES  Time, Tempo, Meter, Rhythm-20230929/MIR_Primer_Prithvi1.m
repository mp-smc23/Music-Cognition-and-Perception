%% GETTING STARTED, LOADING AND PLAYING AUDIO FILES

% TIP 1: EXECUTE A SINGLE BLOCK OF CODE BY SELECTING IT AND PRESSING 'F9'
% INSTEAD OF PRESSING 'F5' AND EXECUTING THE ENTIRE SCRIPT

% TIP 2: IF A SCRIPT EXECUTION PROCESS IN MATLAB TAKES TOO LONG, PRESS 
% CTRL (CMD) + C TO ABORT IT

% START BY CLEARING ALL VARIABLES AND FIGURES FROM MATLAB
clear all

% CHECK WHETHER MIRTOOLBOX PATH PROPERLY SET
% HOME -> SET PATH -> ADD WITH SUBFOLDERS -> MIRtoolbox1.7.2 DIRECTORY
% YOU SHOULD SEE SOMETHING LIKE MATLAB VERSION XXXXXX ON RUNNING
ver mirtoolbox

% PLAY BACK A TEST AUDIO FILE
mirplay('utanmyra.wav')

% TO PLAY ALL FILES INSIDE THE CURRENT FOLDER USE:
mirplay('Folder')

%% AUDIO VISUALIZATION, RMS ENERGY EVOLUTION

% WAVEFORM - miraudio FUNCTION - OPENS A NEW FIGURE WITH AUDIO WAVE GRAPH
miraudio('utanmyra.wav')

% TO DISPLAY WAVEFORMS OF AN ENTIRE FOLDER, USE:
miraudio('Folder')

% EXTRACTING A PART OF THE AUDIO FILE - EG. BETWEEN T = 1sec and T = 3 sec
excerpt = miraudio('utanmyra.wav','Extract',1,3);

% AND THEN PLAY IT BACK
mirplay(excerpt)

% RMS ENERGY - ENTIRE FILE
mirrms('utanmyra.wav')

% RMS ENERGY - TEMPORAL EVOLUTION (FRAMEWISE)
mirrms('utanmyra.wav','Frame')

% VISUALIZE RMS CURVE WHILE SIMULTANEOUSLY PLAYING FILE - MIR PLAYER
% NOTE: TOGGLE CHECKBOX ON TOP LEFT TO DISPLAY GRAPH (!!)
framewiseRMS = mirrms('utanmyra.wav','Frame');
mirplayer(framewiseRMS)

% DO THE SAME FOR AN AUDIO EXCERPT
excerpt = miraudio('utanmyra.wav','Extract',1,3);
mirrms(excerpt)
framewiseRMS_Excerpt = mirrms(excerpt,'Frame')

%% TEMPO ESTIMATION - 1 (STEP BY STEP UNDERSTANDING OF PROCESS)

% GOALS:
% To get familiar with TEMPO ESTIMATION from AUDIO using the MIR Toolbox.
% To ASSESS THE PERFORMANCE of the tempo estimation method.

% LET US LOOK AT THE DIFFERENT STAGES OF TEMPO ESTIMATION

% LOAD FILE AS AN MIRAUDIO
d = miraudio('utanmyra.wav')

% LOOK AT ITS ENVELOPE (d) AND ITS HALF-WAVE RECTIFIED VERSION (e)
mirenvelope(d)
e = mirenvelope(d,'Halfwavediff')

% DECOMPOSE THE AUDIO INTO FREQUENCY BANDS USING A FILTER BANK
f = mirfilterbank(d)

% CALCULATE HALF-WAVE RECTIFIED DIFFERENTIATED ENVELOPE WITHIN EACH FREQ
% BAND
ee = mirenvelope(f,'HalfwaveDiff')

% SUM THE ENVELOPES ACROSS FREQUENCY BANDS
s = mirsum(ee,'Centered') 

% CALCULATE THE AUTORCORRELATION OF THIS ENVELOPE SUM
ac = mirautocor(s) 
 
% APPLY THE RESONANCE MODEL TO THIS AUTOCORRELATION
ac = mirautocor(s,'Resonance') 
 
% FIND PEAKS IN THE AUTOCORRELATION FUNCTION
p = mirpeaks(ac) 
mirgetdata(p)

% ESTIMATE THE PERIODICITY (AKA TEMPO) OF THESE PEAKS
t = mirtempo(p,'Total',1)

% ALL THAT WE DID SO FAR IS PART OF THE MIRTOOLBOX 'tempo' FUNCTION
help mirtempo

% WE CAN SIMPLY WRITE
[t,ac] = mirtempo('utanmyra.wav')

% WE CAN TOGGLE THE RESONANCE MODEL ON AND OFF BY SIMPLY WRITING:
[t,ac] = mirtempo('utanmyra.wav','Resonance',0)

% THE FOLLOWING EXCERPTS HAVE VARIABLE TEMPI, AND FRAME-BASED ANALYSIS CAN
% BE USED TO ESTIMATE THIS VARIATION AS FOLLOWS:
[t1,p1] = mirtempo('laksin.wav','Frame')
[t2,p2] = mirtempo('czardas.wav','Frame')

% WHAT IS THE RANGE OF TEMPO VARIATION?
help mirhisto
h1 = mirhisto(t1)
h2 = mirhisto(t2)

%% TEMPO ESTIMATION - 2

% SET CURRENT FOLDER TO TEMPO_ESTIMATION_EXP (IN LEFT PANE)

% LISTEN TO THE ORIGINAL FILE - CONSTANT TEMPO OF 120 BPM
mirplay('Beat_Normal.wav')

% CALCULATE OVERALL TEMPO OF AN AUDIO FILE
mirtempo('Beat_Normal.wav')

% VISUALIZE EVOLUTION OVER TIME
tempoEvo = mirtempo('Beat_Normal.wav','Frame');
mirplayer(tempoEvo)

% SAME PROCESS BUT FOR A FILE WITH VARIABLE TEMPO
tempoEvo_2 = mirtempo('Beat_FastSlow.wav','Frame',3);
mirplayer(tempoEvo_2)

% DOES THE CURVE MATCH WHAT YOU HEAR? IF NOT, THEN CAN YOU THINK OF WHY
% THAT MIGHT BE?

% BUT WHAT HAPPENS WHEN THE AUDIO IS LESS CLEAR?
% LET'S SEE WHAT HAPPENS WHEN MORE AND MORE REVERB IS ADDED TO THE BEAT
mirplay('Beat_ReverbMix.wav')
mirtempo('Beat_ReverbMix.wav')
% AND EVEN MORE REVERB
mirplay('Beat_ReverbFull.wav')
mirtempo('Beat_ReverbFull.wav')

% PULSE CLARITY PROVIDES AN ESTIMATE OF THE STRENGTH OF THE PULSATION
% LET'S COMPARE! HIGHER VALUE = CLEARER PULSE
mirpulseclarity('Beat_Normal.wav')
mirpulseclarity('Beat_ReverbMix.wav')
mirpulseclarity('Beat_ReverbFull.wav')
% HOW WELL DO THESE NUMBERS AGREE WITH WHAT YOU HEAR?

% END OF TIMING CLASS EXAMPLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SPECTRAL ANALYSIS

% LOOK AT FREQUENCY SPECTRUM (AVERAGED ACROSS ENTIRE FILE LENGTH) - NOT
% VERY INFORMATIVE FOR SOUNDS THAT CHANGE IN TIME
mirspectrum('utanmyra.wav')

% ZOOM IN ON A SPECIFIC FREQUENCY REGION, FOR EG. BELOW 3000 HZ
mirspectrum('utanmyra.wav','Max',3000)

% LOOK AT HOW THE SPECTRUM EVOLVES OVER TIME, CAN ALSO ZOOM IN SIMILARLY
% RUN LINES SEPARATELY TO OBSERVE THE DIFFERENCE IN DETAIL (F9)
mirspectrum('utanmyra.wav','Frame')

% VISUALIZE WHILE PLAYING
spectrum = mirspectrum('utanmyra.wav','Frame','Max',3000);
mirplayer(spectrum)

% THE SAME CAN BE DONE FOR AN EXCERPT OF AUDIO
excerpt = miraudio('utanmyra.wav','Extract',1,3);
mirspectrum(excerpt,'Frame','Max',3000)

%% SPECTRAL FLUX, BRIGHTNESS AND SPECTRAL CENTROID

% SPECTRAL FLUX INDICATES HOW QUICKLY THE POWER SPECTRUM OF THE SIGNAL IS
% CHANGING - SHOWS IMPORTANT EVENTS IN THE SIGNAL (E.G. TRANSIENTS) 

spectrum = mirspectrum('utanmyra.wav', 'Frame');
mirflux(spectrum)

% IN THE utanmyra FILE THESE PEAKS ARE MOST LIKELY THE PIANO KEY PRESSES)
% LET'S CHECK THIS BY VISUALIZING SPECTRAL FLUX DURING PLAYBACK
spectrum = mirspectrum('utanmyra.wav', 'Frame');
flux = mirflux(spectrum);
mirplayer(flux)

% BRIGHTNESS - CORRELATED WITH HIGH FREQUENCY CONTENT IN THE SOUND
% HIGH BRIGHTNESS VALUES - MOST ENERGY IN HIGH FREQUENCY REGISTERS
% LOW BRIGHTNESS VALUES - MOST ENERGY IN LOW FREQUENCY REGISTERS
% LET'S LOOK AT IT FRAMEWISE
audio = miraudio('utanmyra.wav');
brightness = mirbrightness(audio,'Frame');
mirplayer(brightness)

% EXERCISE: CALCULATE BRIGHTNESS FOR A FOLDER AND PLAY FILES BACK IN
% INCREASING ORDER OF BRIGHTNESS
% SET CURRENT FOLDER TO BRIGHTNESS_EXP IN MATLAB (IN LEFT PANE)
brightness_folder = mirbrightness('Folder');
mirplay('Folder','Increasing',brightness_folder);
% DO THE FILES PLAY BACK IN THE EXPECTED ORDER?

% SPECTRAL CENTROID - FREQUENCY AROUND WHICH SOUND ENERGY IS CENTERED
% HIGH AND LOW VALUES FUNCTION SIMILARLY TO BRIGHTNESS - LET'S COMPARE!
audio = miraudio('utanmyra.wav');
centroid = mircentroid(audio, 'Frame');
mirplayer(centroid)

% REPEAT THE BRIGHTNESS EXERCISE - SET CURRENT FOLDER TO BRIGHTNESS_EXP
centroid_folder = mircentroid('Folder');
mirplay('Folder', 'Increasing', centroid_folder)
% SAME ORDER AS BEFORE?

%% SENSORY ROUGHNESS

% THIS IS RELATED TO SENSORY DISSONANCE - HIGH ROUGHNESS IS PRESENT WHEN
% THE SOUND IS HARSH AND INHARMONIC - LET'S DEMONSTRATE THIS
audio = miraudio('roughnessDemo.wav');
roughness = mirroughness(audio, 'Frame');
mirplayer(roughness)

% EXERCISE - PLAY BACK FILES IN INCREASING ORDER OF ROUGHNESS
% SET CURRENT FOLDER TO ROUGHNESS_EXP (IN LEFT PANE)
roughness_folder = mirmean(mirroughness('Folder'));
mirplay('Folder','Increasing', roughness_folder)
% DOES THAT ORDER SOUND RIGHT??

%% ONSET DETECTION

% SET CURRENT FOLDER TO TEMPO_ESTIMATION_EXP (IN LEFT PANE) - WE USE THE
% SAME FILES HERE
onsets = mironsets('Beat_Normal.wav');
mirplayer(onsets)
% DOES IT SEEM TO CAPTURE ALL THE ONSETS OF ALL INSTRUMENTS EQUALLY WELL?
% ANY IDEAS AS TO WHY?

% LET'S SEE HOW IT LOOKS FOR THE REVERB-Y BEATS
onsets2 = mironsets('Beat_ReverbMix.wav');
mirplayer(onsets2)

onsets3 = mironsets('Beat_ReverbFull.wav');
mirplayer(onsets3)
% ANY IDEAS AS TO WHY THE CURVE CHANGES IN THIS MANNER?

% DETECT NOTE ATTACK AND RELEASE PHASES (ZOOM IN ON EACH HIT TO SEE)
onsets_AR = mironsets('Beat_Normal.wav','Attacks','Releases');
mirplayer(onsets_AR)

% SEGMENT THE AUDIO FILES AT ONSET POSITIONS AND PLAY BACK
onsets_AR = mironsets('Beat_Normal.wav','Attacks');
onsets_AR_Seg = mirsegment('Beat_Normal.wav',onsets_AR);
mirplay(onsets_AR_Seg)

%% ATTACK SLOPE AND EVENT DENSITY

% ATTACK SLOPE - HIGH VALUE IMPLIES STEEP ATTACK => IMPULSIVE SOUND
% AND VICE VERSA - COMPARE FOR DRUM BEAT FILES
mirattackslope('Beat_Normal.wav')
ylim([0 100])
mirattackslope('Beat_ReverbFull.wav')
ylim([0 100])

% EVENT DENSITY - HIGH VALUE - MANY NOTES IN FRAME
eventDensity = mireventdensity('Beat_wFill.wav','Frame',1);
mirplayer(eventDensity)
% CAN YOU TELL WHERE THE FAST DRUM ROLL IS, JUST FROM THE GRAPH?

%% PITCH AND TONALITY

% SET CURRENT FOLDER TO PITCH_EXP (IN LEFT PANE)

% PLOT PITCH CONTOUR OF THE AUDIO FILE
pitch = mirpitch('ascendingScale.wav','Frame');
mirplayer(pitch)

% VIEW ENERGY DISTRIBUTION ACROSS PITCH CLASSES
mirchromagram('ascendingScale.wav')

% COMPUTE KEY STRENGTH (PROBABILITY OF EACH KEY 
% MAJOR = BLUE, MINOR = RED
mirkeystrength('ascendingScale.wav')

% MOST PROBABLE KEY (Correct is C MAJOR)
mirkey('ascendingScale.wav')

% TRY THE SAME FOR A POLYPHONIC PIECE (Correct is C# MINOR or E MAJOR)
mirplay('POLY_MUSIC_GTR.wav')
mirchromagram('POLY_MUSIC_GTR.wav')
mirkeystrength('POLY_MUSIC_GTR.wav')
mirkey('POLY_MUSIC_GTR.wav')
mirkeysom('POLY_MUSIC_GTR.wav')             % 2D Visualizer

% WHAT ABOUT FOR AN AMBIGUOUS PIECE?
mirplay('POLY_AMBIGUOUS.wav')
mirchromagram('POLY_AMBIGUOUS.wav')
mirkeystrength('POLY_AMBIGUOUS.wav')
mirkey('POLY_AMBIGUOUS.wav')
mirkeysom('POLY_AMBIGUOUS.wav')             % SEE HOW IT'S LESS DEFINED

%% SEGMENTATION AND SIMILARITY

% Pending - Not sure if of interest

