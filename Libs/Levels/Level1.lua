return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.11.0",
  orientation = "orthogonal",
  width = 8,
  height = 6,
  tilewidth = 16,
  tileheight = 16,
  nextobjectid = 16,
  properties = {},
  tilesets = {
    {
      name = "OfficalV1",
      firstgid = 1,
      tilewidth = 16,
      tileheight = 16,
      spacing = 0,
      margin = 0,
      image = "../TileSets/OfficalV1.png",
      imagewidth = 80,
      imageheight = 64,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "Ground",
      x = 0,
      y = 0,
      width = 8,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12,
        12, 12, 12, 12, 12, 12, 12, 12
      }
    },
    {
      type = "tilelayer",
      name = "OnGroundArt",
      x = 0,
      y = 0,
      width = 8,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 6, 4,
        0, 2684354569, 3, 0, 0, 0, 1610612742, 0,
        0, 0, 1, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "objectgroup",
      name = "Objects Layer",
      visible = true,
      opacity = 1,
      properties = {},
      objects = {
        {
          id = 1,
          name = "",
          type = "ToggleTile",
          shape = "rectangle",
          x = 112,
          y = 48,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 13,
          visible = true,
          properties = {
            ["Trigger"] = "1"
          }
        },
        {
          id = 2,
          name = "",
          type = "BoxButton",
          shape = "rectangle",
          x = 96,
          y = 64,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 15,
          visible = true,
          properties = {
            ["Trigger"] = "1"
          }
        },
        {
          id = 3,
          name = "",
          type = "Box",
          shape = "rectangle",
          x = 32,
          y = 64,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 14,
          visible = true,
          properties = {}
        },
        {
          id = 5,
          name = "",
          type = "Robot",
          shape = "rectangle",
          x = 32,
          y = 80,
          width = 0,
          height = 0,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {}
        }
      }
    },
    {
      type = "tilelayer",
      name = "Walls",
      x = 0,
      y = 0,
      width = 8,
      height = 6,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        13, 13, 13, 13, 13, 13, 13, 13,
        13, 0, 0, 0, 0, 0, 0, 13,
        13, 0, 0, 0, 0, 0, 0, 0,
        13, 0, 0, 0, 0, 0, 10, 13,
        13, 0, 0, 0, 0, 0, 0, 13,
        13, 13, 13, 13, 13, 13, 13, 13
      }
    },
    {
      type = "objectgroup",
      name = "Wall Objects",
      visible = false,
      opacity = 1,
      properties = {},
      objects = {
        {
          id = 11,
          name = "",
          type = "Wall",
          shape = "rectangle",
          x = 0,
          y = 0,
          width = 128,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "",
          type = "Wall",
          shape = "rectangle",
          x = 112,
          y = 16,
          width = 16,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "",
          type = "Wall",
          shape = "rectangle",
          x = 112,
          y = 48,
          width = 16,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 14,
          name = "",
          type = "Wall",
          shape = "rectangle",
          x = 0,
          y = 16,
          width = 16,
          height = 64,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 15,
          name = "",
          type = "Wall",
          shape = "rectangle",
          x = 0,
          y = 80,
          width = 128,
          height = 16,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
