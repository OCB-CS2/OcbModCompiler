@echo off

set ROSLYN_PATH_ORG=%ROSLYN_PATH%
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Enterprise\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
set ROSLYN_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\Roslyn
if exist "%ROSLYN_PATH%\csc.exe" goto HasRoslyn
echo %ROSLYN_PATH%
set ROSLYN_PATH=%ROSLYN_PATH_ORG%
set ROSLYN_PATH_ORG=
echo Error: Roslyn compiler (csc.exe) not found
echo Error: Define ROSLYN_PATH env var to point to it
exit /b 2

:HasRoslyn

if exist "%PATH_CS2_MANAGED%" goto HasManaged
echo Error: CS2 Managed dll directory not found
echo Error: Define PATH_CS2_MANAGED env var to point to it
exit /b 2

:HasManaged

"%ROSLYN_PATH%\csc.exe" /target:library /out:%* /nologo ^
/noconfig /nowarn:1701,1702,2008 /fullpaths /nostdlib+ /errorreport:prompt /warn:4 /define:TRACE ^
/debug:pdbonly /filealign:512 /optimize+ /errorendlocation /preferreduilang:en-US /highentropyva+ ^
/lib:"%PATH_CS2_MANAGED%\..\..\BepInEx\core" ^
/reference:"0Harmony.dll" ^
/reference:"BepInEx.Harmony.dll" ^
/reference:"BepInEx.Preloader.dll" ^
/reference:"BepInEx.dll" ^
/reference:"HarmonyXInterop.dll" ^
/reference:"Mono.Cecil.Mdb.dll" ^
/reference:"Mono.Cecil.Pdb.dll" ^
/reference:"Mono.Cecil.Rocks.dll" ^
/reference:"Mono.Cecil.dll" ^
/reference:"MonoMod.RuntimeDetour.dll" ^
/reference:"MonoMod.Utils.dll" ^
/lib:"%PATH_CS2_MANAGED%" ^
/reference:"Accessibility.dll" ^
/reference:"Backtrace.Unity.dll" ^
/reference:"Cinemachine.dll" ^
/reference:"Cohtml.RenderingBackend.dll" ^
/reference:"Cohtml.Runtime.dll" ^
/reference:"Colossal.ATL.dll" ^
/reference:"Colossal.AssetPipeline.Native.dll" ^
/reference:"Colossal.AssetPipeline.dll" ^
/reference:"Colossal.CharacterSystem.dll" ^
/reference:"Colossal.Collections.dll" ^
/reference:"Colossal.Core.dll" ^
/reference:"Colossal.IO.AssetDatabase.dll" ^
/reference:"Colossal.IO.dll" ^
/reference:"Colossal.Localization.dll" ^
/reference:"Colossal.Logging.dll" ^
/reference:"Colossal.Mathematics.dll" ^
/reference:"Colossal.Mono.Cecil.dll" ^
/reference:"Colossal.OdinSerializer.dll" ^
/reference:"Colossal.PSI.Common.dll" ^
/reference:"Colossal.PSI.Discord.dll" ^
/reference:"Colossal.PSI.PdxSdk.dll" ^
/reference:"Colossal.PSI.Steamworks.dll" ^
/reference:"Colossal.Plugins.dll" ^
/reference:"Colossal.UI.Binding.dll" ^
/reference:"Colossal.UI.dll" ^
/reference:"Unity.Burst.Unsafe.dll" ^
/reference:"Unity.Burst.dll" ^
/reference:"Unity.Collections.LowLevel.ILSupport.dll" ^
/reference:"Unity.Collections.dll" ^
/reference:"Unity.Deformations.dll" ^
/reference:"Unity.Entities.Hybrid.HybridComponents.dll" ^
/reference:"Unity.Entities.Hybrid.dll" ^
/reference:"Unity.Entities.UI.dll" ^
/reference:"Unity.Entities.dll" ^
/reference:"Unity.InputSystem.ForUI.dll" ^
/reference:"Unity.InputSystem.dll" ^
/reference:"Unity.InternalAPIEngineBridge.002.dll" ^
/reference:"Unity.Mathematics.Extensions.Hybrid.dll" ^
/reference:"Unity.Mathematics.Extensions.dll" ^
/reference:"Unity.Mathematics.dll" ^
/reference:"Unity.MemoryProfiler.dll" ^
/reference:"Unity.Profiling.Core.dll" ^
/reference:"Unity.RenderPipelines.Core.Runtime.dll" ^
/reference:"Unity.RenderPipelines.Core.ShaderLibrary.dll" ^
/reference:"Unity.RenderPipelines.HighDefinition.Config.Runtime.dll" ^
/reference:"Unity.RenderPipelines.HighDefinition.Runtime.dll" ^
/reference:"Unity.RenderPipelines.ShaderGraph.ShaderGraphLibrary.dll" ^
/reference:"Unity.Scenes.dll" ^
/reference:"Unity.ScriptableBuildPipeline.dll" ^
/reference:"Unity.Serialization.dll" ^
/reference:"Unity.TextMeshPro.dll" ^
/reference:"Unity.Timeline.dll" ^
/reference:"Unity.Transforms.Hybrid.dll" ^
/reference:"Unity.Transforms.dll" ^
/reference:"Unity.VisualEffectGraph.Runtime.dll" ^
/reference:"UnityEngine.AIModule.dll" ^
/reference:"UnityEngine.ARModule.dll" ^
/reference:"UnityEngine.AccessibilityModule.dll" ^
/reference:"UnityEngine.AndroidJNIModule.dll" ^
/reference:"UnityEngine.AnimationModule.dll" ^
/reference:"UnityEngine.AssetBundleModule.dll" ^
/reference:"UnityEngine.AudioModule.dll" ^
/reference:"UnityEngine.ClothModule.dll" ^
/reference:"UnityEngine.ClusterInputModule.dll" ^
/reference:"UnityEngine.ClusterRendererModule.dll" ^
/reference:"UnityEngine.ContentLoadModule.dll" ^
/reference:"UnityEngine.CoreModule.dll" ^
/reference:"UnityEngine.DSPGraphModule.dll" ^
/reference:"UnityEngine.DirectorModule.dll" ^
/reference:"UnityEngine.GIModule.dll" ^
/reference:"UnityEngine.GameCenterModule.dll" ^
/reference:"UnityEngine.GridModule.dll" ^
/reference:"UnityEngine.HotReloadModule.dll" ^
/reference:"UnityEngine.IMGUIModule.dll" ^
/reference:"UnityEngine.ImageConversionModule.dll" ^
/reference:"UnityEngine.InputLegacyModule.dll" ^
/reference:"UnityEngine.InputModule.dll" ^
/reference:"UnityEngine.JSONSerializeModule.dll" ^
/reference:"UnityEngine.LocalizationModule.dll" ^
/reference:"UnityEngine.NVIDIAModule.dll" ^
/reference:"UnityEngine.ParticleSystemModule.dll" ^
/reference:"UnityEngine.PerformanceReportingModule.dll" ^
/reference:"UnityEngine.Physics2DModule.dll" ^
/reference:"UnityEngine.PhysicsModule.dll" ^
/reference:"UnityEngine.ProfilerModule.dll" ^
/reference:"UnityEngine.PropertiesModule.dll" ^
/reference:"UnityEngine.RuntimeInitializeOnLoadManagerInitializerModule.dll" ^
/reference:"UnityEngine.ScreenCaptureModule.dll" ^
/reference:"UnityEngine.SharedInternalsModule.dll" ^
/reference:"UnityEngine.SpriteMaskModule.dll" ^
/reference:"UnityEngine.SpriteShapeModule.dll" ^
/reference:"UnityEngine.StreamingModule.dll" ^
/reference:"UnityEngine.SubstanceModule.dll" ^
/reference:"UnityEngine.SubsystemsModule.dll" ^
/reference:"UnityEngine.TLSModule.dll" ^
/reference:"UnityEngine.TerrainModule.dll" ^
/reference:"UnityEngine.TerrainPhysicsModule.dll" ^
/reference:"UnityEngine.TextCoreFontEngineModule.dll" ^
/reference:"UnityEngine.TextCoreTextEngineModule.dll" ^
/reference:"UnityEngine.TextRenderingModule.dll" ^
/reference:"UnityEngine.TilemapModule.dll" ^
/reference:"UnityEngine.UI.dll" ^
/reference:"UnityEngine.UIElementsModule.dll" ^
/reference:"UnityEngine.UIModule.dll" ^
/reference:"UnityEngine.UmbraModule.dll" ^
/reference:"UnityEngine.UnityAnalyticsCommonModule.dll" ^
/reference:"UnityEngine.UnityAnalyticsModule.dll" ^
/reference:"UnityEngine.UnityConnectModule.dll" ^
/reference:"UnityEngine.UnityCurlModule.dll" ^
/reference:"UnityEngine.UnityTestProtocolModule.dll" ^
/reference:"UnityEngine.UnityWebRequestAssetBundleModule.dll" ^
/reference:"UnityEngine.UnityWebRequestAudioModule.dll" ^
/reference:"UnityEngine.UnityWebRequestModule.dll" ^
/reference:"UnityEngine.UnityWebRequestTextureModule.dll" ^
/reference:"UnityEngine.UnityWebRequestWWWModule.dll" ^
/reference:"UnityEngine.VFXModule.dll" ^
/reference:"UnityEngine.VRModule.dll" ^
/reference:"UnityEngine.VehiclesModule.dll" ^
/reference:"UnityEngine.VideoModule.dll" ^
/reference:"UnityEngine.VirtualTexturingModule.dll" ^
/reference:"UnityEngine.WindModule.dll" ^
/reference:"UnityEngine.XRModule.dll" ^
/reference:"UnityEngine.dll" ^
/reference:"System.ComponentModel.Composition.dll" ^
/reference:"System.Configuration.Install.dll" ^
/reference:"System.Configuration.dll" ^
/reference:"System.Core.dll" ^
/reference:"System.Data.DataSetExtensions.dll" ^
/reference:"System.Data.dll" ^
/reference:"System.Drawing.dll" ^
/reference:"System.EnterpriseServices.dll" ^
/reference:"System.IO.Compression.FileSystem.dll" ^
/reference:"System.IO.Compression.dll" ^
/reference:"System.Net.Http.dll" ^
/reference:"System.Numerics.dll" ^
/reference:"System.Runtime.Serialization.Formatters.Soap.dll" ^
/reference:"System.Runtime.Serialization.dll" ^
/reference:"System.Runtime.dll" ^
/reference:"System.Security.dll" ^
/reference:"System.ServiceModel.Internals.dll" ^
/reference:"System.ServiceProcess.dll" ^
/reference:"System.Transactions.dll" ^
/reference:"System.Windows.Forms.dll" ^
/reference:"System.Xml.Linq.dll" ^
/reference:"System.Xml.dll" ^
/reference:"System.dll" ^
/reference:"Newtonsoft.Json.dll" ^
/reference:"mscorlib.dll" ^
/reference:"netstandard.dll" ^
/reference:Microsoft.CSharp.dll ^
/subsystemversion:6.00 /utf8output /deterministic+ /langversion:9.0

:end
