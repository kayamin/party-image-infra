# EKS の NodeGroup で用いる IAM role を定義
resource "aws_iam_role" "eks-cluster-node-role" {
  name = "eks-cluster-node-role"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-cluster-node-role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-cluster-node-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-node-role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-cluster-node-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-node-role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-cluster-node-role.name
}

// アプリケーションで必要な権限を付与, S3, Dynamo, Rekognition, SQS
resource "aws_iam_role_policy_attachment" "s3-full" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.eks-cluster-node-role.name
}

resource "aws_iam_role_policy_attachment" "dynamodb-full" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
  role       = aws_iam_role.eks-cluster-node-role.name
}

resource "aws_iam_role_policy_attachment" "rekognition-full" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
  role       = aws_iam_role.eks-cluster-node-role.name
}

resource "aws_iam_role_policy_attachment" "sqs-full" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  role       = aws_iam_role.eks-cluster-node-role.name
}


