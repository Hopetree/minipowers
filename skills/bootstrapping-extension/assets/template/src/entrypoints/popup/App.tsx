{{#if emoji}}
// 图标方案：Emoji — 适合简单插件
// 不要额外引入图标库，统一使用 emoji 作为图标元素

export default function App() {
  return (
    <div className="w-80 min-h-60 p-4 bg-white">
      <div className="flex items-center gap-3 mb-4">
        <span className="text-2xl" role="img" aria-label="logo">
          🧩
        </span>
        <h1 className="text-lg font-semibold text-gray-900">
          {{EXTENSION_NAME}}
        </h1>
      </div>
      <p className="text-sm text-gray-600">
        {{EXTENSION_DESCRIPTION}}
      </p>
    </div>
  );
}
{{else}}
// 图标方案：Lucide — 适合功能较多的插件
// 统一使用 lucide-react 图标组件，不引入 emoji

import { Puzzle } from 'lucide-react';

export default function App() {
  return (
    <div className="w-80 min-h-60 p-4 bg-white">
      <div className="flex items-center gap-3 mb-4">
        <Puzzle className="w-6 h-6 text-blue-600" />
        <h1 className="text-lg font-semibold text-gray-900">
          {{EXTENSION_NAME}}
        </h1>
      </div>
      <p className="text-sm text-gray-600">
        {{EXTENSION_DESCRIPTION}}
      </p>
    </div>
  );
}
{{/if}}
