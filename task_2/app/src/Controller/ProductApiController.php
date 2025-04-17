<?php

namespace App\Controller;

use App\Entity\Product;
use App\Repository\ProductRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\SerializerInterface;

#[Route('/api/product')]
class ProductApiController extends AbstractController
{
    private $entityManager;
    private $productRepository;
    private $serializer;

    public function __construct(EntityManagerInterface $entityManager, ProductRepository $productRepository, SerializerInterface $serializer)
    {
        $this->entityManager = $entityManager;
        $this->productRepository = $productRepository;
        $this->serializer = $serializer;
    }

    #[Route('', name: 'api_product_index', methods: ['GET'])]
    public function index(): JsonResponse
    {
        $products = $this->productRepository->findAll();
        $data = $this->serializer->serialize($products, 'json', ['groups' => 'product:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('', name: 'api_product_create', methods: ['POST'])]
    public function create(Request $request): JsonResponse
    {
        $data = json_decode($request->getContent(), true);
        $product = new Product();
        $product->setName($data['name'] ?? '');
        $product->setPrice($data['price'] ?? 0.0);
        $product->setDescription($data['description'] ?? null);

        $this->entityManager->persist($product);
        $this->entityManager->flush();

        $data = $this->serializer->serialize($product, 'json', ['groups' => 'product:read']);
        return new JsonResponse($data, 201, [], true);
    }

    #[Route('/{id}', name: 'api_product_show', methods: ['GET'])]
    public function show(int $id): JsonResponse
    {
        $product = $this->productRepository->find($id);
        if (!$product) {
            return new JsonResponse(['error' => 'Product not found'], 404);
        }
        $data = $this->serializer->serialize($product, 'json', ['groups' => 'product:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('/{id}', name: 'api_product_update', methods: ['PUT'])]
    public function update(int $id, Request $request): JsonResponse
    {
        $product = $this->productRepository->find($id);
        if (!$product) {
            return new JsonResponse(['error' => 'Product not found'], 404);
        }

        $data = json_decode($request->getContent(), true);
        $product->setName($data['name'] ?? $product->getName());
        $product->setPrice($data['price'] ?? $product->getPrice());
        $product->setDescription($data['description'] ?? $product->getDescription());

        $this->entityManager->flush();

        $data = $this->serializer->serialize($product, 'json', ['groups' => 'product:read']);
        return new JsonResponse($data, 200, [], true);
    }

    #[Route('/{id}', name: 'api_product_delete', methods: ['DELETE'])]
    public function delete(int $id): JsonResponse
    {
        $product = $this->productRepository->find($id);
        if (!$product) {
            return new JsonResponse(['error' => 'Product not found'], 404);
        }

        $this->entityManager->remove($product);
        $this->entityManager->flush();

        return new JsonResponse(null, 204);
    }
}