using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(InvertColoursRenderer), PostProcessEvent.AfterStack, "Custom/Invert")]
public sealed class InvertColours : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Invert effect intensity.")]
    public FloatParameter threshold = new FloatParameter { value = 0.5f };
}

public sealed class InvertColoursRenderer : PostProcessEffectRenderer<InvertColours>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Invert"));
        sheet.properties.SetFloat("_Threshold", settings.threshold);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}