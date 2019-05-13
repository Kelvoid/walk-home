using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(LookUpTextureRenderer), PostProcessEvent.AfterStack, "Custom/LUT")]
public sealed class LookUpTexture : PostProcessEffectSettings
{
    //[Range(0f, 1f), Tooltip("Invert effect intensity.")]
    //public FloatParameter threshold = new FloatParameter { value = 0.5f };

    public ColorParameter col1 = new ColorParameter();
    public ColorParameter col2 = new ColorParameter();
    public ColorParameter col3 = new ColorParameter();
    public ColorParameter col4 = new ColorParameter();
}

public sealed class LookUpTextureRenderer : PostProcessEffectRenderer<LookUpTexture>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/LUT"));
        sheet.properties.SetColor("_Color1", settings.col1);
        sheet.properties.SetColor("_Color2", settings.col2);
        sheet.properties.SetColor("_Color3", settings.col3);
        sheet.properties.SetColor("_Color4", settings.col4);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}