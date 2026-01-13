import {onCall, HttpsError} from "firebase-functions/v2/https";
import {setGlobalOptions} from "firebase-functions/v2";

// Set default region for all functions
setGlobalOptions({region: "europe-west1"});

/**
 * Example callable function.
 * Replace this with your actual functions.
 */
export const helloWorld = onCall(async (request) => {
  // Optionally verify authentication
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated");
  }

  return {
    message: "Hello from Firebase!",
    uid: request.auth.uid,
  };
});
