using UnityEngine;

namespace Experimental
{
    public class Movement : MonoBehaviour
    {
        public enum MovementType { Rotate, Move, MoveAndRotate }

        [SerializeField]
        private MovementType type;

        [Header("Move Paramter")]
        private Vector3 startPosition;

        [SerializeField]
        private float maximumSteps = 1f;

        [SerializeField]
        private float moveSpeed = 1f;

        [Header("Rotate Paramter")]
        private Quaternion startRotation;

        [SerializeField]
        private float maximumAngel = 60f;

        [SerializeField]
        private float rotationSpeed = 1f;

        private void Start()
        {
            startPosition = transform.position;
            startRotation = transform.rotation;
        }

        private void Update()
        {
            switch (type)
            {
                case MovementType.Rotate:
                    Rotate();
                    break;

                case MovementType.Move:
                    Move();
                    break;

                case MovementType.MoveAndRotate:
                    Move();
                    Rotate();
                    break;

                default:
                    break;
            }
        }

        private void Move()
        {
            transform.position = startPosition + Vector3.up * Mathf.Sin(Time.timeSinceLevelLoad * moveSpeed) * maximumSteps;
        }

        private void Rotate()
        {
            transform.rotation = Quaternion.Euler(startRotation.eulerAngles.x, (maximumAngel * Mathf.Sin(Time.timeSinceLevelLoad * rotationSpeed)), startRotation.eulerAngles.z);
        }
    }
}