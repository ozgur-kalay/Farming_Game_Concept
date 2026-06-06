@tool
extends Control


@export var texture: Texture2D:
	get: return texture
	set(val):
		texture = val
		var tex_rect: TextureRect = find_child("TextureRect")
		if tex_rect:
			tex_rect.texture = self.texture
