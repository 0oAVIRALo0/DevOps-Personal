import { Navigate } from "react-router-dom";

const ProtectedRoute = ({ children }) => {
  // Assume you are checking for a token or some authentication condition
  const isAuthenticated = localStorage.getItem("token");

  if (!isAuthenticated) {
    // Redirect to the login page if not authenticated
    return <Navigate to="/login" replace />;
  }

  // Render the child components if authenticated
  return children;
};

export default ProtectedRoute;
