import { useState } from 'react'
import { Authenticator } from '@aws-amplify/ui-react'
import { fetchAuthSession } from 'aws-amplify/auth'
import '@aws-amplify/ui-react/styles.css'
import Chatbot from './components/Chatbot'
import {
  createUser,
  generatePlan,
  analyzeImage,
  generateUploadUrl,
  uploadFileToS3,
} from './api'

function App() {
  const [goal, setGoal] = useState('')
  const [age, setAge] = useState('')
  const [weight, setWeight] = useState('')
  const [activityLevel, setActivityLevel] = useState('')
  const [workoutPlan, setWorkoutPlan] = useState([])
  const [mealPlan, setMealPlan] = useState([])

  const [imageName, setImageName] = useState('')
  const [selectedFile, setSelectedFile] = useState(null)
  const [labels, setLabels] = useState([])
  const [uploadStatus, setUploadStatus] = useState('')

  const profileData = {
    goal,
    age,
    weight,
    activity_level: activityLevel,
  }

  const saveProfile = async (user) => {
    try {
      const result = await createUser({
        user_id: user.username,
        profile_data: profileData,
      })

      console.log('Profile Response:', result)
      alert('Profile saved successfully')
    } catch (error) {
      console.error('API Error:', error)
      alert('Failed to save profile')
    }
  }

  const handleGeneratePlan = async (user) => {
    try {
      const result = await generatePlan({
        user_id: user.username,
        profile_data: profileData,
      })

      console.log('Plan Response:', result)

      setWorkoutPlan(result.workout_plan || [])
      setMealPlan(result.meal_plan || [])

      alert('Plan generated successfully')
    } catch (error) {
      console.error('Plan Error:', error)
      alert('Failed to generate plan')
    }
  }

  const handleAnalyzeImage = async () => {
    if (!imageName) {
      alert('Please enter an image name')
      return
    }

    try {
      const session = await fetchAuthSession()
      const token = session.tokens?.idToken?.toString()

      const result = await analyzeImage(imageName, token)

      console.log('Image Analysis Response:', result)

      setLabels(result.labels || [])

      if (result.error) {
        alert(result.error)
      } else {
        alert('Image analysis complete')
      }
    } catch (error) {
      console.error('Image Analysis Error:', error)
      alert('Failed to analyze image')
    }
  }

  const handleUploadAndAnalyze = async () => {
    if (!selectedFile) {
      alert('Please choose an image file')
      return
    }

    try {
      setUploadStatus('Requesting upload URL...')
      setLabels([])

      const session = await fetchAuthSession()
      const token = session.tokens?.idToken?.toString()

      const uploadUrlResult = await generateUploadUrl(
        selectedFile.name,
        selectedFile.type,
        token
      )

      console.log('Upload URL Response:', uploadUrlResult)

      if (uploadUrlResult.error) {
        alert(uploadUrlResult.error)
        setUploadStatus('Failed to generate upload URL')
        return
      }

      setUploadStatus('Uploading file to S3...')

      const uploadResponse = await uploadFileToS3(
        uploadUrlResult.upload_url,
        selectedFile
      )

      if (!uploadResponse.ok) {
        throw new Error('S3 upload failed')
      }

      setUploadStatus('Analyzing uploaded image...')

      const analysisResult = await analyzeImage(
        uploadUrlResult.image_name,
        token
      )

      console.log('Uploaded Image Analysis Response:', analysisResult)

      setLabels(analysisResult.labels || [])
      setImageName(uploadUrlResult.image_name)

      if (analysisResult.error) {
        alert(analysisResult.error)
        setUploadStatus('Image analysis failed')
      } else {
        alert('Upload and analysis complete')
        setUploadStatus('Upload and analysis complete')
      }
    } catch (error) {
      console.error('Upload and Analysis Error:', error)
      alert('Failed to upload and analyze image')
      setUploadStatus('Failed to upload and analyze image')
    }
  }

  return (
    <Authenticator>
      {({ signOut, user }) => (
        <main>
          <h1>AWS Cloud-Native Fitness App</h1>

          <p>Welcome {user?.username}</p>

          <h2>User Profile</h2>

          <div>
            <label>Goal:</label>
            <br />
            <select
              value={goal}
              onChange={(e) => setGoal(e.target.value)}
            >
              <option value="">Select Goal</option>
              <option value="Weight Loss">Weight Loss</option>
              <option value="Muscle Gain">Muscle Gain</option>
              <option value="Maintenance">Maintenance</option>
            </select>
          </div>

          <br />

          <div>
            <label>Age:</label>
            <br />
            <input
              type="number"
              value={age}
              onChange={(e) => setAge(e.target.value)}
            />
          </div>

          <br />

          <div>
            <label>Weight (kg):</label>
            <br />
            <input
              type="number"
              value={weight}
              onChange={(e) => setWeight(e.target.value)}
            />
          </div>

          <br />

          <div>
            <label>Activity Level:</label>
            <br />
            <select
              value={activityLevel}
              onChange={(e) => setActivityLevel(e.target.value)}
            >
              <option value="">Select Activity Level</option>
              <option value="Low">Low</option>
              <option value="Moderate">Moderate</option>
              <option value="High">High</option>
            </select>
          </div>

          <br />

          <button onClick={() => saveProfile(user)}>
            Save Profile
          </button>

          <br />
          <br />

          <button onClick={() => handleGeneratePlan(user)}>
            Generate Workout & Meal Plan
          </button>

          {workoutPlan.length > 0 && (
            <section>
              <h2>Workout Plan</h2>
              <ul>
                {workoutPlan.map((item, index) => (
                  <li key={index}>{item}</li>
                ))}
              </ul>
            </section>
          )}

          {mealPlan.length > 0 && (
            <section>
              <h2>Meal Plan</h2>
              <ul>
                {mealPlan.map((item, index) => (
                  <li key={index}>{item}</li>
                ))}
              </ul>
            </section>
          )}

          <hr />

          <section>
            <h2>Media Upload & Analysis</h2>

            <p>Choose a new image to upload to S3 and analyze with Rekognition.</p>

            <input
              type="file"
              accept="image/*"
              onChange={(e) => setSelectedFile(e.target.files[0])}
            />

            <br />
            <br />

            <button onClick={handleUploadAndAnalyze}>
              Upload & Analyze Image
            </button>

            {uploadStatus && <p>{uploadStatus}</p>}

            <hr />

            <h3>Analyze Existing S3 Image</h3>

            <p>Or enter an existing image name from S3.</p>

            <input
              type="text"
              value={imageName}
              onChange={(e) => setImageName(e.target.value)}
              placeholder="Example: VD 1.png"
            />

            <br />
            <br />

            <button onClick={handleAnalyzeImage}>
              Analyze Existing Image
            </button>

            {imageName && (
              <p>
                <strong>Current image name:</strong> {imageName}
              </p>
            )}

            {labels.length > 0 && (
              <div>
                <h3>Detected Labels</h3>
                <ul>
                  {labels.map((label, index) => (
                    <li key={index}>
                      {label.name} - {label.confidence}%
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </section>

          <hr />

<Chatbot />

<br />

<button onClick={signOut}>
  Sign Out
</button>
        </main>
      )}
    </Authenticator>
  )
}

export default App