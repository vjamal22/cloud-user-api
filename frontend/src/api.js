const API_BASE_URL = 'https://17u9ta4fi2.execute-api.us-east-1.amazonaws.com/dev'

export async function createUser(userData) {
  const response = await fetch(`${API_BASE_URL}/users`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(userData),
  })

  return response.json()
}

export async function savePreferences(preferencesData, token) {
  const response = await fetch(`${API_BASE_URL}/preferences`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: token,
    },
    body: JSON.stringify(preferencesData),
  })

  return response.json()
}

export async function generatePlan(planData) {
  const response = await fetch(`${API_BASE_URL}/plan`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(planData),
  })

  return response.json()
}

export async function analyzeImage(imageName, token) {
  const response = await fetch(`${API_BASE_URL}/upload`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: token,
    },
    body: JSON.stringify({
      image_name: imageName,
    }),
  })

  return response.json()
}

export async function generateUploadUrl(fileName, fileType, token) {
  const response = await fetch(`${API_BASE_URL}/generate-upload-url`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: token,
    },
    body: JSON.stringify({
      file_name: fileName,
      file_type: fileType,
    }),
  })

  return response.json()
}

export async function uploadFileToS3(uploadUrl, file) {
  const response = await fetch(uploadUrl, {
    method: 'PUT',
    headers: {
      'Content-Type': file.type,
    },
    body: file,
  })

  return response
}