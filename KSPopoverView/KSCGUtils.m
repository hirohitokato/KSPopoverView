//
//  KSCGUtils.m
//
//  Copyright 2010, 2011 KatokichiSoft. All rights reserved.
//

#import "KSCGUtils.h"
#import "UIColor-Expanded.h"

static void pathRoundRect(CGRect rect, CGFloat radius, CGContextRef context);
static float perceptualGlossFractionForColor(float *inputComponents);
static void perceptualCausticColorForColor(float *inputComponents, float *outputComponents);

@implementation KSCGUtils

float perceptualGlossFractionForColor(float *inputComponents) {
    const float REFLECTION_SCALE_NUMBER = 0.2;
    const float NTSC_RED_FRACTION = 0.299;
    const float NTSC_GREEN_FRACTION = 0.587;
    const float NTSC_BLUE_FRACTION = 0.114;
	
    float glossScale =
	NTSC_RED_FRACTION * inputComponents[0] +
	NTSC_GREEN_FRACTION * inputComponents[1] +
	NTSC_BLUE_FRACTION * inputComponents[2];
    glossScale = pow(glossScale, REFLECTION_SCALE_NUMBER);
    return glossScale;
}

void perceptualCausticColorForColor(float *inputComponents,
									float *outputComponents) {
    const float CAUSTIC_FRACTION = 0.60;
    const float COSINE_ANGLE_SCALE = 1.4;
    const float MIN_RED_THRESHOLD = 0.95;
    const float MAX_BLUE_THRESHOLD = 0.7;
    const float GRAYSCALE_CAUSTIC_SATURATION = 0.2;
    
    UIColor *source =
	[UIColor
	 colorWithRed:inputComponents[0]
	 green:inputComponents[1]
	 blue:inputComponents[2]
	 alpha:inputComponents[3]];
	
    float hue, saturation, brightness, alpha;
    [source hue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	
    float targetHue, targetSaturation, targetBrightness;
    [[UIColor yellowColor] hue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha];
    
    if (saturation < 1e-3)
    {
        hue = targetHue;
        saturation = GRAYSCALE_CAUSTIC_SATURATION;
    }
	
    if (hue > MIN_RED_THRESHOLD)
    {
        hue -= 1.0;
    }
    else if (hue > MAX_BLUE_THRESHOLD)
    {
        [[UIColor magentaColor] hue:&targetHue saturation:&targetSaturation brightness:&targetBrightness alpha:&alpha];
    }
	
    float scaledCaustic = CAUSTIC_FRACTION * 0.5 * (1.0 + cos(COSINE_ANGLE_SCALE * M_PI * (hue - targetHue)));
	
    UIColor *targetColor =
	[UIColor
	 colorWithHue:hue * (1.0 - scaledCaustic) + targetHue * scaledCaustic
	 saturation:saturation
	 brightness:brightness * (1.0 - scaledCaustic) + targetBrightness * scaledCaustic
	 alpha:inputComponents[3]];

	for (int i=0; i<CGColorGetNumberOfComponents(targetColor.CGColor); i++) {
		outputComponents[i] = CGColorGetComponents(targetColor.CGColor)[i];
	}
    if (CGColorGetNumberOfComponents(targetColor.CGColor) == 3)
    {
        outputComponents[3] = 1.0;
    }
}

typedef struct {
    CGFloat color[4];
    CGFloat caustic[4];
    CGFloat expCoefficient;
    CGFloat expScale;
    CGFloat expOffset;
    CGFloat initialWhite;
    CGFloat finalWhite;
} GlossParameters;

void glossInterpolation(void *info, const float *input,
							   float *output) {
    GlossParameters *params = (GlossParameters *)info;
	
    float progress = *input;
    if (progress < 0.5)
    {
        progress = progress * 2.0;
		
        progress =
		1.0 - params->expScale * (expf(progress * -params->expCoefficient) - params->expOffset);
		
        float currentWhite = progress * (params->finalWhite - params->initialWhite) + params->initialWhite;
        
        output[0] = params->color[0] * (1.0 - currentWhite) + currentWhite;
        output[1] = params->color[1] * (1.0 - currentWhite) + currentWhite;
        output[2] = params->color[2] * (1.0 - currentWhite) + currentWhite;
        output[3] = params->color[3] * (1.0 - currentWhite) + currentWhite;
    } else {
        progress = (progress - 0.5) * 2.0;
		
        progress = params->expScale *
		(expf((1.0 - progress) * -params->expCoefficient) - params->expOffset);
		
        output[0] = params->color[0] * (1.0 - progress) + params->caustic[0] * progress;
        output[1] = params->color[1] * (1.0 - progress) + params->caustic[1] * progress;
        output[2] = params->color[2] * (1.0 - progress) + params->caustic[2] * progress;
        output[3] = params->color[3] * (1.0 - progress) + params->caustic[3] * progress;
    }
}

+ (void)pathForRoundRect:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius {

	CGFloat lx = CGRectGetMinX(rect);
	CGFloat cx = CGRectGetMidX(rect);
	CGFloat rx = CGRectGetMaxX(rect);
	CGFloat by = CGRectGetMinY(rect);
	CGFloat cy = CGRectGetMidY(rect);
	CGFloat ty = CGRectGetMaxY(rect);
	
	CGContextMoveToPoint(context, lx, cy);
	CGContextAddArcToPoint(context, lx, by, cx, by, radius);
	CGContextAddArcToPoint(context, rx, by, rx, cy, radius);
	CGContextAddArcToPoint(context, rx, ty, cx, ty, radius);
	CGContextAddArcToPoint(context, lx, ty, lx, cy, radius);
	CGContextClosePath(context);
}

+ (void)drawGlossGradient:(CGContextRef)context
					color:(UIColor*)color
				   inRect:(CGRect)inRect {

    const float EXP_COEFFICIENT = 1.2;
    const float REFLECTION_MAX = 0.80;
    const float REFLECTION_MIN = 0.40;
    
    GlossParameters params;
    
    params.expCoefficient = EXP_COEFFICIENT;
    params.expOffset = expf(-params.expCoefficient);
    params.expScale = 1.0 / (1.0 - params.expOffset);

	for (int i=0; i<CGColorGetNumberOfComponents(color.CGColor); i++) {
		params.color[i] = CGColorGetComponents(color.CGColor)[i];
	}
    if (CGColorGetNumberOfComponents(color.CGColor) == 3) {
        params.color[3] = 1.0;
    }
    
    perceptualCausticColorForColor(params.color, params.caustic);
    
    float glossScale = perceptualGlossFractionForColor(params.color);
	
    params.initialWhite = glossScale * REFLECTION_MAX;
    params.finalWhite = glossScale * REFLECTION_MIN;
	
    static const float input_value_range[2] = {0, 1};
    static const float output_value_ranges[8] = {0, 1, 0, 1, 0, 1, 0, 1};
    CGFunctionCallbacks callbacks = {0, glossInterpolation, NULL};
    
    CGFunctionRef gradientFunction = CGFunctionCreate((void *)&params,
													  1, // number of input values to the callback
													  input_value_range,
													  4, // number of components (r, g, b, a)
													  output_value_ranges,
													  &callbacks);
    
    CGPoint startPoint = CGPointMake(CGRectGetMinX(inRect), CGRectGetMinY(inRect));
    CGPoint endPoint = CGPointMake(CGRectGetMinX(inRect), CGRectGetMaxY(inRect));
	
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGShadingRef shading = CGShadingCreateAxial(colorspace, startPoint,
												endPoint, gradientFunction, FALSE, FALSE);
    
    CGContextSaveGState(context);
    CGContextClipToRect(context, inRect);
    CGContextDrawShading(context, shading);
    CGContextRestoreGState(context);
    
    CGShadingRelease(shading);
    CGColorSpaceRelease(colorspace);
    CGFunctionRelease(gradientFunction);
	return;
}

+ (void)clipRoundRect:(CGRect)rect
		   withRadius:(CGFloat)radius
			inContext:(CGContextRef)context {

	[self pathForRoundRect:context rect:rect radius:radius];
	CGContextClip(context);
}

+ (void)drawRoundRect:(CGRect)rect
		   withRadius:(CGFloat)radius
			inContext:(CGContextRef)context {

	[self pathForRoundRect:context rect:rect radius:radius];
	CGContextDrawPath(context, kCGPathEOFillStroke);
}
@end
