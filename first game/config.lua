--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

local aspectRatio = display.pixelHeight / display.pixelWidth

application =
{
	content =
	{
		width = aspectRatio > 1.5 and 320 or math.floor(480 / aspectRatio),
		height = aspectRatio < 1.5 and 480 or math.floor(320 * aspectRatio ), 
		scale = "letterBox",
		fps = 60,
		
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
	},
}
