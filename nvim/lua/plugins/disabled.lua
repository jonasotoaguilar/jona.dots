-- Plugins deshabilitados (configs movidas a disabled-backup/)
-- Para reactivar: mover el .lua de vuelta a plugins/ y cambiar enabled a true

return {
  -- bufferline — deshabilitado a favor de la barra nativa
  { "akinsho/bufferline.nvim", enabled = false },

  -- AI plugins deshabilitados
  { "yetone/avante.nvim", enabled = false },
  { "CopilotC-Nvim/CopilotChat.nvim", enabled = false },
  { "olimorris/codecompanion.nvim", enabled = false },
  { "tris203/precognition.nvim", enabled = false },
  { "sphamba/smear-cursor.nvim", enabled = false },

  -- AI activo
  { "coder/claudecode.nvim", enabled = true },
  { "NickvanDyke/opencode.nvim", enabled = true },
}
