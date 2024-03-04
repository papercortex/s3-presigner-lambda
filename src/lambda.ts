import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";
import { generatePutPresignedUrl } from "./generatePresignedUrl";

export async function handler(
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> {
  const bucketName = process.env.BUCKET_NAME;
  if (!bucketName) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Server configuration error" }),
    };
  }

  try {
    if (!event.body) throw new Error("Request body is missing");

    const body = JSON.parse(event.body);
    const objectName = body.filename;
    const contentType = body.contentType || "binary/octet-stream";

    if (!objectName) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Filename is required" }),
      };
    }

    const url = await generatePutPresignedUrl(
      bucketName,
      objectName,
      contentType
    );

    return { statusCode: 200, body: JSON.stringify({ url }) };
  } catch (error) {
    if (error instanceof SyntaxError) {
      return {
        statusCode: 400,
        body: JSON.stringify({ message: "Invalid JSON format" }),
      };
    } else {
      console.error(error);
      return {
        statusCode: 500,
        body: JSON.stringify({
          message: `Error generating presigned URL: ${
            error instanceof Error ? error.message : error
          }`,
        }),
      };
    }
  }
}
