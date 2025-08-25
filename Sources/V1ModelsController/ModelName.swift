//
//  ModelName.swift
//  XCIntelligenceBridge
//
//  Created by treastrain on 2025/08/25.
//

import Foundation

nonisolated enum ModelName: Sendable {
    static func name(for id: String) -> String? {
        table[id]
    }

    static let table = [
        /* ---------- Google Gemini ---------- */
        "models/embedding-gecko-001": "Embedding Gecko (001)",
        "models/gemini-1.5-pro-latest": "Gemini 1.5 Pro (latest)",
        "models/gemini-1.5-pro-002": "Gemini 1.5 Pro (002)",
        "models/gemini-1.5-pro": "Gemini 1.5 Pro",
        "models/gemini-1.5-flash-latest": "Gemini 1.5 Flash (latest)",
        "models/gemini-1.5-flash": "Gemini 1.5 Flash",
        "models/gemini-1.5-flash-002": "Gemini 1.5 Flash (002)",
        "models/gemini-1.5-flash-8b": "Gemini 1.5 Flash-8B",
        "models/gemini-1.5-flash-8b-001": "Gemini 1.5 Flash-8B (001)",
        "models/gemini-1.5-flash-8b-latest": "Gemini 1.5 Flash-8B (latest)",
        "models/gemini-2.5-pro-preview-03-25": "Gemini 2.5 Pro (preview-03-25)",
        "models/gemini-2.5-flash-preview-05-20": "Gemini 2.5 Flash (preview-05-20)",
        "models/gemini-2.5-flash": "Gemini 2.5 Flash",
        "models/gemini-2.5-flash-lite-preview-06-17": "Gemini 2.5 Flash-Lite (preview-06-17)",
        "models/gemini-2.5-pro-preview-05-06": "Gemini 2.5 Pro (preview-05-06)",
        "models/gemini-2.5-pro-preview-06-05": "Gemini 2.5 Pro (preview-06-05)",
        "models/gemini-2.5-pro": "Gemini 2.5 Pro",
        "models/gemini-2.0-flash-exp": "Gemini 2.0 Flash Experimental",
        "models/gemini-2.0-flash": "Gemini 2.0 Flash",
        "models/gemini-2.0-flash-001": "Gemini 2.0 Flash (001)",
        "models/gemini-2.0-flash-exp-image-generation": "Gemini 2.0 Flash Preview Image Generation Experimental",
        "models/gemini-2.0-flash-lite-001": "Gemini 2.0 Flash-Lite (001)",
        "models/gemini-2.0-flash-lite": "Gemini 2.0 Flash-Lite",
        "models/gemini-2.0-flash-preview-image-generation": "Gemini 2.0 Flash Preview Image Generation",
        "models/gemini-2.0-flash-lite-preview-02-05": "Gemini 2.0 Flash-Lite (preview-02-05)",
        "models/gemini-2.0-flash-lite-preview": "Gemini 2.0 Flash-Lite (preview)",
        "models/gemini-2.0-pro-exp": "Gemini 2.0 Pro Experimental",
        "models/gemini-2.0-pro-exp-02-05": "Gemini 2.0 Pro Experimental (02-05)",
        "models/gemini-exp-1206": "Gemini Experimental (1206)",
        "models/gemini-2.0-flash-thinking-exp-01-21": "Gemini 2.0 Flash Thinking Experimental (01-21)",
        "models/gemini-2.0-flash-thinking-exp": "Gemini 2.0 Flash Thinking Experimental",
        "models/gemini-2.0-flash-thinking-exp-1219": "Gemini 2.0 Flash Thinking Experimental (1219)",
        "models/gemini-2.5-flash-preview-tts": "Gemini 2.5 Flash Preview TTS",
        "models/gemini-2.5-pro-preview-tts": "Gemini 2.5 Pro Preview TTS",
        "models/learnlm-2.0-flash-experimental": "LearnLM 2.0 Flash Experimental",
        "models/gemma-3-1b-it": "Gemma 3 1B",
        "models/gemma-3-4b-it": "Gemma 3 4B",
        "models/gemma-3-12b-it": "Gemma 3 12B",
        "models/gemma-3-27b-it": "Gemma 3 27B",
        "models/gemma-3n-e4b-it": "Gemma 3n E4B",
        "models/gemma-3n-e2b-it": "Gemma 3n E2B",
        "models/gemini-2.5-flash-lite": "Gemini 2.5 Flash-Lite",
        "models/embedding-001": "Embedding 001",
        "models/text-embedding-004": "Text Embedding (004)",
        "models/gemini-embedding-exp-03-07": "Gemini Embedding (exp-03-07)",
        "models/gemini-embedding-exp": "Gemini Embedding (exp)",
        "models/gemini-embedding-001": "Gemini Embedding (001)",
        "models/aqa": "Attributed Question Answering",
        "models/imagen-3.0-generate-002": "Imagen 3 Generate 002",
        "models/imagen-4.0-generate-preview-06-06": "Imagen 4 Generate (preview-06-06)",
        "models/imagen-4.0-ultra-generate-preview-06-06": "Imagen 4 Ultra Generate (preview-06-06)",
        "models/imagen-4.0-generate-001": "Imagen 4 Generate",
        "models/imagen-4.0-ultra-generate-001": "Imagen 4 Ultra Generate",
        "models/imagen-4.0-fast-generate-001": "Imagen 4 Fast Generate",
        "models/veo-2.0-generate-001": "Veo 2",
        "models/veo-3.0-generate-preview": "Veo 3 Preview",
        "models/veo-3.0-fast-generate-preview": "Veo 3 Fast preview",
        "models/gemini-2.5-flash-preview-native-audio-dialog": "Gemini 2.5 Flash Native Audio Preview",
        "models/gemini-2.5-flash-exp-native-audio-thinking-dialog": "Gemini 2.5 Flash Native Audio Experimental",
        "models/gemini-2.0-flash-live-001": "Gemini 2.0 Flash Live",
        "models/gemini-live-2.5-flash-preview": "Gemini Live 2.5 Flash Preview",
        "models/gemini-2.5-flash-live-preview": "Gemini 2.5 Flash Live Preview",
    ]
}
