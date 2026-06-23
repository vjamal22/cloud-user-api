function AnalyticsDashboard({ workoutPlan, mealPlan, labels }) {
  return (
    <section>
      <h2>Analytics Dashboard</h2>

      <p><strong>Workout items generated:</strong> {workoutPlan.length}</p>
      <p><strong>Meal items generated:</strong> {mealPlan.length}</p>
      <p><strong>Image labels detected:</strong> {labels.length}</p>

      <h3>Progress Summary</h3>
      <ul>
        <li>Profile setup: In progress</li>
        <li>Plan generation: {workoutPlan.length > 0 || mealPlan.length > 0 ? 'Completed' : 'Not completed yet'}</li>
        <li>Image analysis: {labels.length > 0 ? 'Completed' : 'Not completed yet'}</li>
        <li>Chatbot: Completed</li>
      </ul>
    </section>
  )
}

export default AnalyticsDashboard