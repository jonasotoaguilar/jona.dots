-- Neotest adapters para JS/TS (React): vitest + jest
-- Detección automática por proyecto (si usa vitest o jest, lo toma)
return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {},
      ["neotest-jest"] = {},
    },
  },
}
