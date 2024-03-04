import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import {
  GetObjectCommand,
  PutObjectCommand,
  S3Client,
} from "@aws-sdk/client-s3";

const s3Client = new S3Client({});

export async function generatePutPresignedUrl(
  bucketName: string,
  objectName: string,
  contentType: string,
  expiration: number = 3600
): Promise<string> {
  const command = new PutObjectCommand({
    Bucket: bucketName,
    Key: objectName,
    ContentType: contentType,
  });

  return await getSignedUrl(s3Client, command, { expiresIn: expiration });
}

export async function generateGetPresignedUrl(
  bucketName: string,
  objectName: string,
  expiration: number = 3600
): Promise<string> {
  const command = new GetObjectCommand({
    Bucket: bucketName,
    Key: objectName,
  });

  return await getSignedUrl(s3Client, command, { expiresIn: expiration });
}
