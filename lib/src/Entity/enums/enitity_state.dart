// ignore_for_file: constant_identifier_names

enum EntityState {
  // New client-side entity - hasn't been fetched from or created on the server
  New,

  // In process of creating the entity on the server
  Creating,

  // Entity created on server and potentially in the process of pushing updates to the server
  Ready,

  // Unused... for now
  Updating,

  // Entity in the process of being deleted
  Deleting,

  // Entity has been deleted on the server
  Deleted
}
