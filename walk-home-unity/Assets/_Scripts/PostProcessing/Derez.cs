using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(DerezRenderer), PostProcessEvent.AfterStack, "Custom/Derez")]
public sealed class Derez : PostProcessEffectSettings
{
    [Range(0f, 256f), Tooltip("Number of tones.")]
    public FloatParameter tones = new FloatParameter { value = 0.5f };
    [Range(0f, 1f), Tooltip("Gamma")]
    public FloatParameter gamma = new FloatParameter { value = 0.5f };
    [Tooltip("Pixel Number X")]
    public FloatParameter pixelNumberX = new FloatParameter { value = 256 };
    [Tooltip("Pixel Number Y")]
    public FloatParameter pixelNumberY = new FloatParameter { value = 256 };
}

public sealed class DerezRenderer : PostProcessEffectRenderer<Derez>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Derez"));
        sheet.properties.SetFloat("_NumCol", settings.tones);
        sheet.properties.SetFloat("_Gamma", settings.gamma);
        sheet.properties.SetFloat("_PixelNumberX", settings.pixelNumberX);
        sheet.properties.SetFloat("_PixelNumberY", settings.pixelNumberY);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}