import { zstdDecompressSync } from "node:zlib";
import type { Fetch } from "../src";

const DECOMPRESSORS: Record<string, (data: Uint8Array) => Buffer> = {
  zstd: zstdDecompressSync,
};

/** The request body as it was before compression, as text or, for `multipart/form-data`, a `Blob`. */
export const decompressedBody = (init: RequestInit | undefined): string | Blob | undefined => {
  const headers = new Headers(init?.headers);
  const encoding = headers.get("content-encoding");
  if (encoding === null) return init?.body as string | Blob | undefined;
  const decompress = DECOMPRESSORS[encoding];
  if (decompress === undefined) throw new Error(`Unexpected Content-Encoding: ${encoding}`);
  const data = decompress(init?.body as Uint8Array);
  return headers.get("content-type")?.startsWith("multipart/form-data")
    ? new Blob([new Uint8Array(data)])
    : data.toString("utf8");
};

export interface RecordedRequest {
  url: string;
  init: RequestInit | undefined;
  /** The body as it was before compression. */
  raw: string | Blob | undefined;
  /** The JSON body, or the `request` part of a `multipart/form-data` body. */
  body: unknown;
  /** The parsed `multipart/form-data` body, if any. */
  form: FormData | undefined;
}

/** Create a fetch mock that records requests and returns supplied responses. */
export const mockFetch = (
  respond: (req: RecordedRequest) => Response | Promise<Response>,
): { fetch: Fetch; requests: RecordedRequest[] } => {
  const requests: RecordedRequest[] = [];
  const fetch: Fetch = async (url, init) => {
    const raw = decompressedBody(init);
    const form =
      raw instanceof Blob
        ? await new Response(raw, { headers: new Headers(init?.headers) }).formData()
        : undefined;
    const text = form === undefined ? raw : form.get("request");
    const body = typeof text === "string" ? JSON.parse(text) : undefined;
    const req = { url, init, raw, body, form };
    requests.push(req);
    return respond(req);
  };
  return { fetch, requests };
};

export const json = (data: unknown, init: ResponseInit = {}): Response =>
  new Response(JSON.stringify(data), {
    ...init,
    headers: { "content-type": "application/json", ...init.headers },
  });
